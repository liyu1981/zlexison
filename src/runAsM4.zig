const std = @import("std");
const m4bin = @embedFile("m4.bin");

pub fn runAsM4(args: [][:0]const u8, exe_path: []const u8) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    // std.debug.print("embed flex: {d} bytes.\n", .{flexbin.len});

    const exe_dir = std.fs.path.dirname(exe_path);
    // std.debug.print("zlex exe dir: {?s}\n", .{zlex_exe_dir});
    const zm4_path = ensureZm4(arena, exe_dir.?) catch |err| {
        std.debug.print("{any}\n", .{err});
        @panic("ensureZm4 failed!");
    };

    const argv = arena.alloc([]const u8, args.len) catch {
        @panic("OOM!");
    };
    argv[0] = zm4_path;
    for (1..args.len) |i| argv[i] = args[i];

    const envmap = std.process.getEnvMap(arena) catch {
        @panic("OOM!");
    };

    const ret = std.process.execve(arena, argv, &envmap);
    std.debug.print("Oops, {any}\n", .{ret});
    std.os.exit(1);
}

fn ensureZm4(allocator: std.mem.Allocator, exe_dir: []const u8) ![]const u8 {
    const zm4_path = try std.fs.path.join(allocator, &[_][]const u8{ exe_dir, "zm4" });

    const cwd = std.fs.cwd();

    cwd.access(zm4_path, .{}) catch {
        return ensureZm4Copy(zm4_path);
    };

    var f = brk: {
        if (std.fs.path.isAbsolute(zm4_path))
            break :brk std.fs.openFileAbsolute(zm4_path, .{}) catch {
                return ensureZm4Copy(zm4_path);
            }
        else
            break :brk cwd.openFile(zm4_path, .{}) catch {
                return ensureZm4Copy(zm4_path);
            };
    };
    const content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    // can not defer close as later we may need to overwrite it
    f.close();
    defer allocator.free(content);

    var hash1: [512 / 8]u8 = undefined;
    _ = &hash1;
    std.crypto.hash.Blake3.hash(content, &hash1, .{});
    var hash2: [512 / 8]u8 = undefined;
    _ = &hash2;
    std.crypto.hash.Blake3.hash(m4bin, &hash2, .{});
    if (!std.mem.eql(u8, &hash1, &hash2)) {
        return ensureZm4Copy(zm4_path);
    }

    return zm4_path;
}

fn ensureZm4Copy(zm4_path: []const u8) ![]const u8 {
    const cwd = std.fs.cwd();
    var f = try cwd.createFile(zm4_path, .{});
    defer f.close();
    try f.writeAll(m4bin);
    try f.chmod(0o0755);
    return zm4_path;
}
