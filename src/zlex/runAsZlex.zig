const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

pub fn run_as_zlex(opts: struct {
    input_file_path: []const u8,
    output_file_path: []const u8,
    zlex_exe: []const u8,
}) !void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    var f: ?std.fs.File = null;
    const writer: std.fs.File.Writer = brk: {
        const trimed_out_path = std.mem.trim(u8, opts.output_file_path, &std.ascii.whitespace);
        if (trimed_out_path.len <= 0) {
            break :brk std.io.getStdOut().writer();
        } else {
            f = try std.fs.cwd().createFile(trimed_out_path, .{});
            // do not close f, let exit do it
            break :brk f.?.writer();
        }
    };
    defer {
        if (f != null) f.?.close();
    }

    const raw_yyc = brk: {
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    opts.zlex_exe,
                    "zflex",
                    "-t",
                    "-R",
                    "--yylineno",
                    "--stack",
                    "--bison-bridge",
                    "--bison-locations",
                    opts.input_file_path,
                },
            },
        });
        result.assertSucceededPanic(.{});
        break :brk result.stdout.?;
    };

    var yyc_final1 = brk: {
        var js_yyc = try jstring.JString.newFromSlice(arena, raw_yyc);
        defer js_yyc.deinit();
        var js_yyc_final = try js_yyc.replaceAll("<stdin>", opts.input_file_path);
        _ = &js_yyc_final;
        break :brk js_yyc_final;
    };
    defer yyc_final1.deinit();

    var yyc_final2 = brk: {
        var js_yyc_final = try yyc_final1.replaceAll("#line", "// #line");
        _ = &js_yyc_final;
        break :brk js_yyc_final;
    };
    defer yyc_final2.deinit();

    // try writer.print("{s}", .{yyc_final2});

    const yyc_final3 = brk: {
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "zig",
                    "fmt",
                    "--stdin",
                },
            },
            .stdin_input = yyc_final2.valueOf(),
        });
        result.assertSucceededPanic(.{});
        break :brk result.stdout.?;
    };

    try writer.print("{s}", .{yyc_final3});
}

extern fn flex_main(argc: usize, argv: [*c]const u8) u8;

pub fn run_as_zflex(args: [][:0]const u8) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();
    const argv_buf = arena.allocSentinel(?[*:0]const u8, args.len, null) catch {
        @panic("Oops! OOM!");
    };
    for (args, 0..) |arg, i| {
        const duped = arena.dupeZ(u8, arg) catch {
            @panic("Oops! OOM!");
        };
        argv_buf[i] = duped.ptr;
    }
    std.os.exit(flex_main(
        args.len,
        @as([*c]const u8, @ptrCast(argv_buf.ptr)),
    ));
}
