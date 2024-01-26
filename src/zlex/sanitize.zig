const std = @import("std");
const FlexParser = @import("flexParser.zig");

pub const SanitizeError = error{
    ZigSyntaxError,
    ContextDefinitionNotFound,
    ContextNotPub,
    ContextDefinedAsComptime,
    ContextDefinedMultipleTimes,
};

pub fn sanitizeParser(parser: *FlexParser) !void {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    var context_node_index: ?u32 = null;

    const stderr = std.io.getStdErr();
    const stderr_config = std.io.tty.detectConfig(stderr);
    const stderr_writer = stderr.writer();
    try stderr_config.setColor(stderr_writer, std.io.tty.Color.red);
    errdefer stderr_config.setColor(stderr_writer, std.io.tty.Color.reset) catch {};
    defer stderr_config.setColor(stderr_writer, std.io.tty.Color.reset) catch {};

    for (parser.context.definitions_cbs.items) |item| {
        const content_z = try allocator.dupeZ(u8, item.content.items);
        defer allocator.free(content_z);
        var item_ast = try std.zig.Ast.parse(allocator, content_z, .zig);
        if (item_ast.errors.len > 0) {
            try stderr_writer.print("found zig syntax error from {s}!\n", .{try formatCodeBlock(allocator, &item)});
            try stderr_writer.print(
                "outstanding error: \n{s}\n",
                .{try format1stError(
                    allocator,
                    &item_ast,
                    item.start.line,
                )},
            );
            return SanitizeError.ZigSyntaxError;
        }
        defer item_ast.deinit(allocator);
        // try std.json.stringify(item_ast, .{ .whitespace = .indent_2 }, stderr_writer);
        if (findContextNode(&item_ast, &item) catch |err| {
            return err;
        }) |cn| {
            if (context_node_index != null) {
                try stderr_writer.print(
                    "2nd context definition found from {s}!\n",
                    .{try formatCodeBlock(allocator, &item)},
                );
                try stderr_writer.print(
                    "{s}",
                    .{
                        try formatProblem(allocator, SanitizeError.ContextDefinedMultipleTimes, &item_ast, cn, &item),
                    },
                );
                return SanitizeError.ContextDefinedMultipleTimes;
            }
            context_node_index = cn;
        }
    }

    if (context_node_index == null) {
        try stderr_writer.writeAll("Can not find any `pub const Context = struct {...}` or `pub var Context = struct {...}` in definitions.\n");
        return SanitizeError.ContextDefinitionNotFound;
    }
}

fn dumpAst(root_ast: *std.zig.Ast) !void {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();
    const private_render = @import("./zig_private_render.zig");
    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit();
    try private_render.renderTree(&buffer, root_ast.*, .{});
    std.debug.print("\n{s}\n", .{buffer.items});
}

fn findContextNode(root_ast: *std.zig.Ast, code_block: *const FlexParser.Context.CodeBlock) !?u32 {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    // try dumpAst(allocator, root_ast);
    const tree_tags = root_ast.nodes.items(.tag);
    const root_decls = root_ast.rootDecls();
    var found_one: ?u32 = null;
    for (root_decls) |decl| {
        switch (tree_tags[decl]) {
            .simple_var_decl => {
                if (root_ast.fullVarDecl(decl)) |var_decl| {
                    // std.debug.print("\n{any}\n===============\n", .{var_decl});
                    const indentifier_lexeme = getTokenLexeme(root_ast, var_decl.ast.mut_token + 1);
                    if (std.mem.eql(u8, indentifier_lexeme, "Context")) {
                        // need to worry about multi Context def in same block as zig syntax will not catch it
                        if (found_one != null) {
                            try std.io.getStdErr().writer().print(
                                "2nd context definition found from {s}!\n",
                                .{try formatCodeBlock(allocator, code_block)},
                            );
                            try std.io.getStdErr().writer().print(
                                "{s}",
                                .{
                                    try formatProblem(allocator, SanitizeError.ContextDefinedMultipleTimes, root_ast, var_decl.ast.mut_token + 1, code_block),
                                },
                            );
                            return SanitizeError.ContextDefinedMultipleTimes;
                        }

                        found_one = try sanitizeContextDecl(root_ast, decl, &var_decl, code_block);
                    }
                }
            },
            else => {},
        }
    }

    return found_one;
}

fn sanitizeContextDecl(
    root_ast: *std.zig.Ast,
    decl: u32,
    var_decl: *const std.zig.Ast.full.VarDecl,
    code_block: *const FlexParser.Context.CodeBlock,
) !u32 {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    var token_index: u32 = 0;
    const r = brk: {
        // check for pub
        if (var_decl.visib_token == null) {
            token_index = var_decl.ast.mut_token;
            break :brk SanitizeError.ContextNotPub;
        }

        // extern should be fine
        if (var_decl.extern_export_token) |extern_export_token| {
            _ = extern_export_token;
        }

        // threadlocal: matter?
        if (var_decl.threadlocal_token) |thread_local_token| {
            _ = thread_local_token;
        }

        // comptime: not allowed
        if (var_decl.comptime_token != null) {
            token_index = var_decl.comptime_token.?;
            break :brk SanitizeError.ContextDefinedAsComptime;
        }

        break :brk if (decl + 1 < root_ast.tokens.len) decl + 1 else decl;
    };

    return r catch |err| {
        try std.io.getStdErr().writer().print("{any} from {s}!\n", .{
            err,
            try formatCodeBlock(allocator, code_block),
        });
        try std.io.getStdErr().writer().print("{s}", .{try formatProblem(
            allocator,
            err,
            root_ast,
            token_index,
            code_block,
        )});
        return err;
    };
}

fn getTokenLexeme(tree: *std.zig.Ast, token_index: std.zig.Ast.TokenIndex) []const u8 {
    var ret = tree.tokenSlice(token_index);
    switch (tree.tokens.items(.tag)[token_index]) {
        .multiline_string_literal_line => {
            if (ret[ret.len - 1] == '\n') ret.len -= 1;
        },
        .container_doc_comment, .doc_comment => {
            ret = std.mem.trimRight(u8, ret, &std.ascii.whitespace);
        },
        else => {},
    }
    return ret;
}

fn format1stError(
    allocator: std.mem.Allocator,
    item_ast: *std.zig.Ast,
    code_block_start_line: usize,
) ![]const u8 {
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    const err = item_ast.errors[0];
    const err_token_loc = item_ast.tokenLocation(0, err.token);
    try buf.writer().print("{s}\n", .{item_ast.source[err_token_loc.line_start..err_token_loc.line_end]});
    if (err_token_loc.column > 0) for (0..err_token_loc.column) |_| try buf.append(' ');
    try buf.writer().print("^\n", .{});
    if (err_token_loc.column > 0) for (0..err_token_loc.column) |_| try buf.append(' ');
    try item_ast.renderError(item_ast.errors[0], buf.writer());
    try buf.writer().print(": line: {d}, col: {d}", .{
        code_block_start_line + err_token_loc.line + 1,
        err_token_loc.column,
    });
    return buf.toOwnedSlice();
}

fn formatProblem(
    allocator: std.mem.Allocator,
    err: anyerror,
    root_ast: *std.zig.Ast,
    token_index: std.zig.Ast.TokenIndex,
    code_block: *const FlexParser.Context.CodeBlock,
) ![]const u8 {
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    const problem_token_loc = root_ast.tokenLocation(0, token_index);
    try buf.writer().print("{s}\n", .{root_ast.source[problem_token_loc.line_start..problem_token_loc.line_end]});
    if (problem_token_loc.column > 0) for (0..problem_token_loc.column) |_| try buf.append(' ');
    try buf.writer().print("^\n", .{});
    if (problem_token_loc.column > 0) for (0..problem_token_loc.column) |_| try buf.append(' ');
    try buf.writer().print("{any}: line: {d}, col: {d}\n", .{
        err,
        code_block.start.line + problem_token_loc.line + 1,
        problem_token_loc.column,
    });
    return buf.toOwnedSlice();
}

fn formatCodeBlock(
    allocator: std.mem.Allocator,
    code_block: *const FlexParser.Context.CodeBlock,
) ![]const u8 {
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    try buf.writer().print("code block(L:{d},C:{d} -> L:{d},C:{d})", .{
        code_block.start.line + 1,
        code_block.start.col,
        code_block.end.line + 1,
        code_block.end.col,
    });
    return buf.toOwnedSlice();
}
