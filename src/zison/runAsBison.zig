const std = @import("std");
const zcmd = @import("zcmd");
const bisonbin = @embedFile("../bison.bin");
const sharebin = @embedFile("../share.tgz.bin");
const sharebin_hash = @embedFile("../share.tgz.bin.hash");
const version = @import("../version.zig");

pub fn runAsBison(
    args: [][:0]const u8,
    opts: struct {
        zison_exe_path: []const u8,
        m4_exe_path: []const u8,
        bison_rel_pkgdatadir: []const u8 = "share/bison",
    },
) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    // std.debug.print("embed bison: {d} bytes.\n", .{bisonbin.len});

    const zison_exe_dir = std.fs.path.dirname(opts.zison_exe_path);
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
    defer envmap.deinit();

    envmap.put("ZISON_VERSION", version.zison_version) catch @panic("ZISON_VERSION set failed!");

    const bison_share_path = ensureShare(arena, zison_exe_dir.?, opts.bison_rel_pkgdatadir) catch @panic("OOM!");

    envmap.put("BISON_PKGDATADIR", bison_share_path) catch @panic("BISON_PKGDATADIR set failed!");
    envmap.put("M4", opts.m4_exe_path) catch @panic("M4 set failed!");

    const ret = std.process.execve(arena, argv, &envmap);
    std.debug.print("Oops, {any}\n", .{ret});
    std.posix.exit(1);
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

fn ensureShare(allocator: std.mem.Allocator, zison_exe_dir: []const u8, bison_rel_pkgdatadir: []const u8) ![]const u8 {
    const pkgdatadir = try std.fs.path.join(allocator, &[_][]const u8{ zison_exe_dir, bison_rel_pkgdatadir });
    const exist = brk: {
        std.fs.accessAbsolute(pkgdatadir, .{}) catch break :brk false;
        break :brk true;
    };
    if (exist) {
        const genuine = brk: {
            const hash_dev_f_path = try std.fs.path.join(allocator, &[_][]const u8{ zison_exe_dir, "share/.zlexison.hash.dev" });
            defer allocator.free(hash_dev_f_path);
            std.fs.accessAbsolute(hash_dev_f_path, .{}) catch {
                const hash_f_path = try std.fs.path.join(allocator, &[_][]const u8{ zison_exe_dir, "share/.zlexison.hash" });
                defer allocator.free(hash_f_path);
                var hash_f = std.fs.openFileAbsolute(hash_f_path, .{}) catch {
                    break :brk false;
                };
                defer hash_f.close();
                const content = hash_f.readToEndAlloc(allocator, std.math.maxInt(usize)) catch {
                    break :brk false;
                };
                defer allocator.free(content);
                break :brk std.mem.eql(u8, content, sharebin_hash);
            };
            break :brk true;
        };
        if (genuine) {
            return pkgdatadir;
        } else {
            return ensureShareByCreate(allocator, zison_exe_dir, bison_rel_pkgdatadir);
        }
    } else {
        return ensureShareByCreate(allocator, zison_exe_dir, bison_rel_pkgdatadir);
    }
}

fn ensureShareByCreate(allocator: std.mem.Allocator, zison_exe_dir: []const u8, bison_rel_pkgdatadir: []const u8) ![]const u8 {
    const pkgdatadir = try std.fs.path.join(allocator, &[_][]const u8{ zison_exe_dir, bison_rel_pkgdatadir });
    const tgz_f_path = try std.fs.path.join(allocator, &[_][]const u8{ zison_exe_dir, "share.tar.gz" });
    defer allocator.free(tgz_f_path);
    var tgz_f = try std.fs.createFileAbsolute(tgz_f_path, .{});
    defer tgz_f.close();
    try tgz_f.writeAll(sharebin);

    {
        var result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ "tar", "xzf", tgz_f_path },
            },
            .cwd = zison_exe_dir,
        });
        defer result.deinit();
        result.assertSucceededPanic(.{ .check_stderr_empty = false });
    }

    {
        var result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ "rm", tgz_f_path },
            },
            .cwd = zison_exe_dir,
        });
        defer result.deinit();
        result.assertSucceededPanic(.{ .check_stderr_empty = false });
    }

    const hash_f_path = try std.fs.path.join(allocator, &[_][]const u8{ zison_exe_dir, "share/.zlexison.hash" });
    defer allocator.free(hash_f_path);
    var hash_f = try std.fs.createFileAbsolute(hash_f_path, .{});
    defer hash_f.close();
    try hash_f.writeAll(sharebin_hash);

    return pkgdatadir;
}
