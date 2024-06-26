const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

pub fn runAsZlex(opts: struct {
    input_file_path: []const u8,
    output_file_path: []const u8,
    zlexison_file_path: ?[]const u8,
    zlex_exe: []const u8,
    need_main_fn: bool,
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
            var autogen_file_out = try jstring.JString.newFromFormat(arena, "{s}.zig", .{std.fs.path.basename(opts.input_file_path)});
            defer autogen_file_out.deinit();
            f = try std.fs.cwd().createFile(autogen_file_out.valueOf(), .{});
            break :brk f.?.writer();
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
        var envmap = try std.process.getEnvMap(arena);
        defer envmap.deinit();
        // zflex in default enabled
        //   -R --yylineno --stack --bison-bridge --bison-locations
        //   %option reject,unput,yymore
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    opts.zlex_exe,
                    "zflex",
                    "-t",
                    if (opts.need_main_fn) "--main" else "--nomain",
                    opts.input_file_path,
                },
            },
            .env_map = &envmap,
        });
        result.assertSucceeded(.{
            .print_cmd_term = false,
            .print_stdout = false,
            .print_stderr = true,
        }) catch {
            std.debug.print("{?s}\n", .{result.stderr});
            std.posix.exit(1);
        };
        break :brk result.stdout.?;
    };

    // following a lot of jstring be created, so remember to use arena to avoid
    // manual deinit
    var raw_yyc_fixed = try (try jstring.JString.newFromSlice(arena, raw_yyc)).replaceAll("<REJECT>;", "REJECT(yyg); loop_control = LOOP_START_YY_FIND_RULE; continue;");

    var yyc_final1 = (try (try raw_yyc_fixed.replaceAll("<stdin>", opts.input_file_path))
        .replaceAll("<stdout>", opts.output_file_path));

    var yyc_final2 = try yyc_final1.replaceAll("#line", "// #line");

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
        result.assertSucceeded(.{
            .print_cmd_term = false,
            .print_stdout = false,
            .print_stderr = false,
        }) catch {
            var err_js = jstring.JString.newFromSlice(arena, result.stderr.?) catch @panic("OOM!");
            const err_js_lines = err_js.split("\n", -1) catch @panic("OOM!");
            std.debug.print("// zig fmt failed with: \n", .{});
            for (err_js_lines) |line| std.debug.print("// {s}\n", .{line});
            std.debug.print("// below is the generated source. \n{s}\n", .{yyc_final2});
            std.posix.exit(1);
        };
        break :brk result.stdout.?;
    };

    try writer.print("{s}", .{yyc_final3});
}

extern fn flex_main(argc: usize, argv: [*c]const u8, m4path: [*c]const u8) u8;

pub fn runAsZflex(args: [][:0]const u8, m4_path: []const u8) void {
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
    const m4pathZ = arena.dupeZ(u8, m4_path) catch {
        @panic("Oops! OOM!");
    };
    std.posix.exit(flex_main(
        args.len,
        @as([*c]const u8, @ptrCast(argv_buf.ptr)),
        m4pathZ.ptr,
    ));
}
