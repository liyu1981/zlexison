const std = @import("std");
const bisonbin = @embedFile("../bison.bin");

pub fn runAsBison(
    args: [][:0]const u8,
    zison_exe_path: []const u8,
    opts: struct {
        bison_rel_pkgdatadir: []const u8 = "share/bison",
    },
) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    // std.debug.print("embed bison: {d} bytes.\n", .{bisonbin.len});

    const zison_exe_dir = std.fs.path.dirname(zison_exe_path);
    // std.debug.print("zison exe dir: {?s}\n", .{zison_exe_dir});
    const zison_bison_path = ensureZisonBison(arena, zison_exe_dir.?) catch |err| {
        std.debug.print("{any}\n", .{err});
        @panic("ensureZisonBison failed!");
    };

    const argv = arena.alloc([]const u8, args.len) catch {
        @panic("OOM!");
    };
    argv[0] = zison_bison_path;
    for (1..args.len) |i| argv[i] = args[i];

    var envmap = std.process.getEnvMap(arena) catch {
        @panic("OOM!");
    };
    const bison_share_path = std.fs.path.join(arena, &[_][]const u8{ zison_exe_dir.?, opts.bison_rel_pkgdatadir }) catch @panic("OOM!");
    envmap.put("BISON_PKGDATADIR", bison_share_path) catch @panic("BISON_PKGDATADIR set failed!");

    const ret = std.process.execve(arena, argv, &envmap);
    std.debug.print("Oops, {any}\n", .{ret});
    std.os.exit(1);
}

fn ensureZisonBison(allocator: std.mem.Allocator, zison_exe_dir: []const u8) ![]const u8 {
    const zison_bison_path = try std.fs.path.join(allocator, &[_][]const u8{ zison_exe_dir, "zison-bison" });

    const cwd = std.fs.cwd();

    cwd.access(zison_bison_path, .{}) catch {
        return ensureZisonBisonCopy(zison_bison_path);
    };

    var f = brk: {
        if (std.fs.path.isAbsolute(zison_bison_path))
            break :brk std.fs.openFileAbsolute(zison_bison_path, .{}) catch {
                return ensureZisonBisonCopy(zison_bison_path);
            }
        else
            break :brk cwd.openFile(zison_bison_path, .{}) catch {
                return ensureZisonBisonCopy(zison_bison_path);
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
    std.crypto.hash.Blake3.hash(bisonbin, &hash2, .{});
    if (!std.mem.eql(u8, &hash1, &hash2)) {
        return ensureZisonBisonCopy(zison_bison_path);
    }

    return zison_bison_path;
}

fn ensureZisonBisonCopy(zison_bison_path: []const u8) ![]const u8 {
    const cwd = std.fs.cwd();
    var f = try cwd.createFile(zison_bison_path, .{});
    defer f.close();
    try f.writeAll(bisonbin);
    try f.chmod(0o0755);
    return zison_bison_path;
}
