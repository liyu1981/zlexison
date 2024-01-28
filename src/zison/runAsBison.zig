const std = @import("std");
const jstring = @import("jstring");

extern fn bison_main(argc: usize, argv: [*c]const u8) u8;

pub fn run_as_bison(args: [][:0]const u8, zison_exe_path: []const u8) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    const zison_exe_dir = std.fs.path.dirname(zison_exe_path);
    if (zison_exe_dir == null) {
        @panic("Oops! Zison exe dir is emptry?");
    }
    var env_map = std.process.getEnvMap(arena) catch {
        @panic("Oops! No EnvMap!");
    };

    if (env_map.get("BISON_PKGDATADIR") == null) {
        setEnvAndRerun(arena, args, zison_exe_dir.?, zison_exe_path, &env_map) catch |err| {
            std.io.getStdErr().writer().print("{any}\n", .{err}) catch {};
            @panic("Oops! set env and rerun failed");
        };
    }

    // normally we should start bison with BISON_PKGDATADIR set in env
    const argv_buf = arena.allocSentinel(?[*:0]const u8, args.len, null) catch {
        @panic("Oops! OOM!");
    };
    for (args, 0..) |arg, i| {
        const duped = arena.dupeZ(u8, arg) catch {
            @panic("Oops! OOM!");
        };
        argv_buf[i] = duped.ptr;
    }
    std.os.exit(bison_main(
        args.len,
        @as([*c]const u8, @ptrCast(argv_buf.ptr)),
    ));
}

fn setEnvAndRerun(
    arena: std.mem.Allocator,
    args: [][:0]const u8,
    zison_exe_dir: []const u8,
    zison_exe_path: []const u8,
    env_map: *std.process.EnvMap,
) !void {
    var pkg_data_dir = try jstring.JString.newFromFormat(arena, "{s}/share/bison", .{zison_exe_dir});
    defer pkg_data_dir.deinit();
    try env_map.put("BISON_PKGDATADIR", pkg_data_dir.valueOf());
    const new_args = try arena.alloc([]const u8, args.len + 1);
    new_args[0] = try arena.dupe(u8, zison_exe_path);
    for (0..args.len) |i| new_args[i + 1] = try arena.dupe(u8, args[0]);
    const execv_error = std.process.execve(arena, new_args, env_map);
    // only error can reach here :)
    try std.io.getStdErr().writer().print("{any}\n", .{execv_error});
    std.os.exit(1);
}
