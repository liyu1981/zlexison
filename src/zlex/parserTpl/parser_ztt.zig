pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("    const std = @import(\"std\");\n    const Parser = @This();\n    const ZA = @import(\"zlexAPI.zig\");\n    const uint_ptr = ZA.uint_ptr;\n    // start condition const\n    ");
    try stream.print("{s}", .{ctx.start_condition});
    try stream.writeAll("\n    export fn zlex_prepare_yy(\n        parser_intptr: uint_ptr,\n        text: [*c]u8,\n        leng: usize,\n        in: uint_ptr, // FILE* as uint_ptr\n        out: uint_ptr, // FIlE* as uint_ptr\n        current_buffer_intptr: uint_ptr,\n        start: usize,\n    ) void {\n        var parser = @as(*Parser, @ptrFromInt(parser_intptr));\n        parser.yy.text = text;\n        parser.yy.leng = leng;\n        parser.yy.in = in;\n        parser.yy.out = out;\n        parser.yy.current_buffer = @as(*ZA.YYBufferState, @ptrFromInt(current_buffer_intptr));\n        parser.yy.start = start;\n    }\n    pub fn lex(this: *Parser) !void {\n        ZA.zlex_setup_parser(@as(usize, @intFromPtr(this)));\n        ZA.yylex();\n    }\n    allocator: std.mem.Allocator,\n    input: ?[]const u8,\n    startCondition: ZA.StartCondition = ZA.StartCondition{},\n    yy: ZA.YY = .{},\n    action: ZA.Action = .{},\n    buffer: ZA.Buffer = .{},\n    context: Context = undefined,\n    pub fn init(args: struct {\n        allocator: std.mem.Allocator,\n        input: ?[]const u8 = null,\n    }) Parser {\n        return Parser{\n            .allocator = args.allocator,\n            .input = args.input,\n            .context = Context.init(args.allocator),\n        };\n    }\n    pub fn deinit(this: *const Parser) void {\n        _ = this;\n    }\n    pub fn readRestLine(parser: *Parser) ![]u8 {\n        var line_array = std.ArrayList(u8).init(parser.allocator);\n        defer line_array.deinit();\n        var c = parser.action.input();\n        while (c != null and c != '\\n') {\n            try line_array.append(@as(u8, @intCast(c.?)));\n            c = parser.action.input();\n        }\n        return line_array.toOwnedSlice();\n    }\n    // generated from ");
    try stream.print("{s}", .{ctx.source_name});
    try stream.writeAll("\n    // definitions + context\n    ");
    try stream.print("{s}", .{ctx.definitions});
    try stream.writeAll("\n    // rule actions\n    ");
    try stream.print("{s}", .{ctx.rule_actions});
    try stream.writeAll("\n    // user code\n    ");
    try stream.print("{s}", .{ctx.user_code});
    try stream.writeAll("\n");
}
