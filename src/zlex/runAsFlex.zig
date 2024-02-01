const std = @import("std");
const flexbin = @embedFile("../flex.bin");

pub fn runAsFlex(args: [][:0]const u8, zlex_exe_path: []const u8) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    // std.debug.print("embed flex: {d} bytes.\n", .{flexbin.len});

    const zlex_exe_dir = std.fs.path.dirname(zlex_exe_path);
    // std.debug.print("zlex exe dir: {?s}\n", .{zlex_exe_dir});
    const zlex_flex_path = ensureZlexFlex(arena, zlex_exe_dir.?) catch |err| {
        std.debug.print("{any}\n", .{err});
        @panic("ensureZlexFlex failed!");
    };

    const argv = arena.alloc([]const u8, args.len) catch {
        @panic("OOM!");
    };
    argv[0] = zlex_flex_path;
    for (1..args.len) |i| argv[i] = args[i];

    const envmap = std.process.getEnvMap(arena) catch {
        @panic("OOM!");
    };

    const ret = std.process.execve(arena, argv, &envmap);
    std.debug.print("Oops, {any}\n", .{ret});
    std.os.exit(1);
}

fn ensureZlexFlex(allocator: std.mem.Allocator, zlex_exe_dir: []const u8) ![]const u8 {
    const zlex_flex_path = try std.fs.path.join(allocator, &[_][]const u8{ zlex_exe_dir, "zlex-flex" });

    const cwd = std.fs.cwd();

    cwd.access(zlex_flex_path, .{}) catch {
        return ensureZlexFlexCopy(zlex_flex_path);
    };

    var f = brk: {
        if (std.fs.path.isAbsolute(zlex_flex_path))
            break :brk std.fs.openFileAbsolute(zlex_flex_path, .{}) catch {
                return ensureZlexFlexCopy(zlex_flex_path);
            }
        else
            break :brk cwd.openFile(zlex_flex_path, .{}) catch {
                return ensureZlexFlexCopy(zlex_flex_path);
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
    std.crypto.hash.Blake3.hash(flexbin, &hash2, .{});
    if (!std.mem.eql(u8, &hash1, &hash2)) {
        return ensureZlexFlexCopy(zlex_flex_path);
    }

    return zlex_flex_path;
}

fn ensureZlexFlexCopy(zlex_flex_path: []const u8) ![]const u8 {
    const cwd = std.fs.cwd();
    var f = try cwd.createFile(zlex_flex_path, .{});
    defer f.close();
    try f.writeAll(flexbin);
    try f.chmod(0o0755);
    return zlex_flex_path;
}
