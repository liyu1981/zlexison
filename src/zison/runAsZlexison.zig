const std = @import("std");
const builtin = @import("builtin");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

const ForkError = anyerror;

pub fn runAsZlexison(
    args: [][:0]const u8,
    opts: struct {
        zison_exe_path: []const u8,
        m4_exe_path: []const u8,
        bison_rel_pkgdatadir: []const u8 = "share/zlexison",
        output_file_path: []const u8,
    },
) !void {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    var output_file_path: [:0]const u8 = undefined;
    const found_output_file_path = brk: {
        var i: usize = 1;
        while (i < args.len) : (i += 1) {
            const arg = args[i];
            if (std.mem.eql(u8, arg, "-o")) {
                if (i + 1 < args.len) {
                    output_file_path = args[i + 1];
                    break :brk true;
                } else {
                    return error.InvalidOption;
                }
            }
        }
        break :brk false;
    };

    const run_args = brk: {
        if (found_output_file_path) {
            const new_args = try arena.alloc([:0]const u8, args.len + 1);
            new_args[0] = args[0];
            new_args[1] = "--no-lines";
            @memcpy(new_args[2..], args[1..]);
            break :brk new_args;
        } else {
            const new_args = try arena.alloc([:0]const u8, args.len + 3);
            new_args[0] = args[0];
            new_args[1] = "-o";
            output_file_path = try ensureZlexisonZigFilePathZ(arena, opts.output_file_path);
            new_args[2] = output_file_path;
            new_args[3] = "--no-lines";
            @memcpy(new_args[4..], args[1..]);
            break :brk new_args;
        }
    };

    const raw_zz = brk: {
        const result = try zcmd.forkAndRun(
            arena,
            ForkAndRunAsZlexisonPayload,
            forkAndRunAsZlexison,
            .{
                .args = run_args,
                .opts = .{
                    .zison_exe_path = opts.zison_exe_path,
                    .m4_exe_path = opts.m4_exe_path,
                    .bison_rel_pkgdatadir = opts.bison_rel_pkgdatadir,
                },
            },
        );
        defer result.deinit();
        result.assertSucceededPanic(.{});

        var f = try std.fs.cwd().openFile(output_file_path, .{});
        defer f.close();
        break :brk try f.readToEndAlloc(arena, std.math.maxInt(usize));
    };

    const final_zz = brk: {
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "zig",
                    "fmt",
                    "--stdin",
                },
            },
            .stdin_input = raw_zz,
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
            std.debug.print("// below is the generated source. \n{s}\n", .{raw_zz});
            std.posix.exit(1);
        };
        break :brk result.stdout.?;
    };

    var f = try std.fs.cwd().createFile(output_file_path, .{});
    defer f.close();
    try f.writeAll(final_zz);
}

const ForkAndRunAsZlexisonPayload = struct {
    args: [][:0]const u8,
    opts: struct {
        zison_exe_path: []const u8,
        m4_exe_path: []const u8,
        bison_rel_pkgdatadir: []const u8 = "share/zlexison",
    },
};

fn forkAndRunAsZlexison(payload: ForkAndRunAsZlexisonPayload) zcmd.RunFnError!void {
    @import("runAsBison.zig").runAsBison(payload.args, .{
        .zison_exe_path = payload.opts.zison_exe_path,
        .m4_exe_path = payload.opts.m4_exe_path,
        .bison_rel_pkgdatadir = payload.opts.bison_rel_pkgdatadir,
    });
}

fn ensureZlexisonZigFilePathZ(arena: std.mem.Allocator, output_file_path: []const u8) ![:0]const u8 {
    const output_file_dir = brk: {
        const maybe_output_file_dir = std.fs.path.dirname(output_file_path);
        if (maybe_output_file_dir) |ofd| {
            break :brk ofd;
        } else {
            break :brk "./";
        }
    };
    const zlexison_output_file = try std.fs.path.join(arena, &[_][]const u8{ output_file_dir, "zlexison.zig" });
    defer arena.free(zlexison_output_file);
    std.fs.cwd().access(zlexison_output_file, .{}) catch {
        return arena.dupeZ(u8, zlexison_output_file);
    };
    std.debug.print("found zlexison.zig in current dir, go forward may overwrite it. Abort!", .{});
    std.posix.exit(1);
}
