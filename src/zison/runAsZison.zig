const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

pub fn runAsZison(opts: struct {
    input_file_path: []const u8,
    output_file_path: []const u8,
    zison_exe: []const u8,
    need_main_fn: bool,
}) !void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    {
        var envmap = try std.process.getEnvMap(arena);
        defer envmap.deinit();

        if (opts.need_main_fn) {
            try envmap.put("ZISON_NEED_MAIN", "1");
        }

        // zbison in default enabled
        //   --locations
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    opts.zison_exe,
                    "zbison",
                    "--locations",
                    "-o",
                    opts.output_file_path,
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
    }

    const raw_tabc = brk: {
        if (std.fs.path.isAbsolute(opts.output_file_path)) {
            const outf = try std.fs.openFileAbsolute(opts.output_file_path, .{});
            defer outf.close();
            break :brk try outf.readToEndAlloc(arena, std.math.maxInt(usize));
        } else {
            const outf = try std.fs.cwd().openFile(opts.output_file_path, .{});
            defer outf.close();
            break :brk try outf.readToEndAlloc(arena, std.math.maxInt(usize));
        }
    };

    var f: ?std.fs.File = null;
    const writer: std.fs.File.Writer = brk: {
        const trimed_out_path = std.mem.trim(u8, opts.output_file_path, &std.ascii.whitespace);
        if (trimed_out_path.len <= 0) {
            @panic("output_file_path is empty, or empty after trimmed!");
        } else {
            f = try std.fs.cwd().createFile(trimed_out_path, .{});
            // do not close f, let exit do it
            break :brk f.?.writer();
        }
    };
    defer {
        if (f != null) f.?.close();
    }

    // following a lot of jstring be created, so remember to use arena to avoid
    // manual deinit
    const raw_tabc_fixed = try (try jstring.JString.newFromSlice(arena, raw_tabc)).replaceAll("#line", "// #line");

    const tabc_final = brk: {
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "zig",
                    "fmt",
                    "--stdin",
                },
            },
            .stdin_input = raw_tabc_fixed.valueOf(),
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
            std.debug.print("// below is the generated source. \n{s}\n", .{raw_tabc_fixed});
            std.posix.exit(1);
        };
        break :brk result.stdout.?;
    };

    try writer.writeAll(tabc_final);
}
