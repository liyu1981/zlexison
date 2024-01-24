pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("    const std = @import(\"std\");\n    const Parser = @This();\n    ");
    try stream.print("{s}", .{ctx.za});
    try stream.writeAll("\n    // start condition const\n    ");
    try stream.print("{s}", .{ctx.start_condition});
    try stream.writeAll("\n    export fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_prepare_yy(\n        parser_intptr: uint_ptr,\n        yyg: uint_ptr,\n        text: [*c]u8,\n        leng: usize,\n        in: uint_ptr, // FILE* as uint_ptr\n        out: uint_ptr, // FIlE* as uint_ptr\n        current_buffer_intptr: uint_ptr,\n        start: usize,\n    ) void {\n        var parser = @as(*Parser, @ptrFromInt(parser_intptr));\n        parser.yy.yyg = yyg;\n        // copy twice to avoid circular import\n        ZA.zyy_yyg_intptr = yyg;\n        parser.yy.text = text;\n        parser.yy.leng = leng;\n        parser.yy.in = in;\n        parser.yy.out = out;\n        parser.yy.current_buffer = @as(*ZA.YYBufferState, @ptrFromInt(current_buffer_intptr));\n        parser.yy.start = start;\n    }\n    pub fn lex(this: *Parser) !void {\n        ZA.zyy_setup_parser(@as(usize, @intFromPtr(this)));\n        _ = ZA.zyylex_init(@as([*c]?*anyopaque, @ptrCast(&this.yy.yyg)));\n\n        // TODO: this is ugly...\n        Parser.ZA.zyy_yyg_intptr = this.yy.yyg;\n\n        if (this.input) |input| {\n            _ = try this.buffer.yy_scan_bytes(input);\n        }\n\n        _ = ZA.zyylex(@as(?*anyopaque, @ptrFromInt(this.yy.yyg)));\n        _ = ZA.zyylex_destroy(@as(?*anyopaque, @ptrFromInt(this.yy.yyg)));\n    }\n    allocator: std.mem.Allocator,\n    input: ?[]const u8,\n    prefix: []const u8,\n    startCondition: ZA.StartCondition = ZA.StartCondition{},\n    yy: ZA.YY = .{},\n    action: ZA.Action = .{},\n    buffer: ZA.Buffer = .{},\n    context: Context = undefined,\n    pub fn init(args: struct {\n        allocator: std.mem.Allocator,\n        input: ?[]const u8 = null,\n        prefix: ?[]const u8 = null,\n    }) Parser {\n        return Parser{\n            .allocator = args.allocator,\n            .input = args.input,\n            .context = Context.init(args.allocator),\n            .prefix = brk: {\n                if (args.prefix) |prefix| {\n                    if (std.mem.startsWith(u8, prefix, \"0123456789\")) {\n                        @panic(\"parser prefix can not start with digits\");\n                    }\n                    if (std.mem.containsAtLeast(u8, prefix, 1, \" \\t\\r\\n\")) {\n                        @panic(\"parser prefix can not contain spaces or newlines\");\n                    }\n                    const trimed = std.mem.trim(u8, prefix, \" \\t\\r\\n\");\n                    if (trimed.len == 0) {\n                        @panic(\"parser prefix can not be empty or string with only spaces.\");\n                    }\n                    break :brk args.allocator.dupe(u8, trimed) catch @panic(\"OOM!\");\n                }\n\n                var buf_arr = std.ArrayList(u8).init(args.allocator);\n                defer buf_arr.deinit();\n                buf_arr.writer().print(\"zyy{d}\", .{std.time.microTimestamp()}) catch @panic(\"OOM!\");\n                break :brk buf_arr.toOwnedSlice() catch @panic(\"OOM!\");\n            },\n        };\n    }\n    pub fn deinit(this: *const Parser) void {\n        this.context.deinit();\n        this.allocator.free(this.prefix);\n    }\n    pub fn readRestLine(parser: *Parser) ![]u8 {\n        var line_array = std.ArrayList(u8).init(parser.allocator);\n        defer line_array.deinit();\n        var c = parser.action.input();\n        while (c != null and c != '\\n') {\n            try line_array.append(@as(u8, @intCast(c.?)));\n            c = parser.action.input();\n        }\n        return line_array.toOwnedSlice();\n    }\n    // generated from ");
    try stream.print("{s}", .{ctx.source_name});
    try stream.writeAll("\n    // definitions + context\n    ");
    try stream.print("{s}", .{ctx.definitions});
    try stream.writeAll("\n    // rule actions\n    ");
    try stream.print("{s}", .{ctx.rule_actions});
    try stream.writeAll("\n    // user code\n    ");
    try stream.print("{s}", .{ctx.user_code});
    try stream.writeAll("\n");
}
