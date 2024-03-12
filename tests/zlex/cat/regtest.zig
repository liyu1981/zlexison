const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("cat.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("cat", cat_test_data, runCatTest);
}

const cat_test_data = .{
    .{
        \\test data, line 1
        ,
        \\test data, line 2
    },
};

fn runCatTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };
    try lexer.init();
    defer lexer.deinit();

    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    lexer.yyg.yyout_r = .{ .buf = &output_buf };

    // prepare 2 tmp files
    var tmp_files = try createTmpFiles(allocator, &[_][]const u8{ input, expected_output });
    var tmp_dir = tmp_files[0].tmp_dir;
    defer tmp_dir.cleanup();

    for (0..tmp_files.len) |i| tmp_files[i].f.close();
    defer {
        for (0..tmp_files.len) |i| tmp_files[i].deinit();
        allocator.free(tmp_files);
    }

    var names_buf: [3]std.ArrayList(u8) = undefined;
    for (0..3) |i| {
        names_buf[i] = std.ArrayList(u8).init(allocator);
    }
    defer {
        for (0..3) |i| names_buf[i].deinit();
    }

    try names_buf[1].writer().print("{s}/{s}/{s}", .{ tmp_files[0].tmp_dir.parent_dir_path, tmp_files[0].tmp_dir.sub_path, tmp_files[0].sub_path });
    try names_buf[2].writer().print("{s}/{s}/{s}", .{ tmp_files[1].tmp_dir.parent_dir_path, tmp_files[1].tmp_dir.sub_path, tmp_files[1].sub_path });

    YYLexer.names = &[_][]u8{ names_buf[0].items, names_buf[1].items, names_buf[2].items };

    lexer.yyg.yyin_r = try std.fs.openFileAbsolute(YYLexer.names[1], .{});

    _ = try lexer.yylex(&yylval_param, &yylloc_param);

    var result_buf = std.ArrayList(u8).init(allocator);
    defer result_buf.deinit();
    try result_buf.writer().print("{s}{s}", .{ input, expected_output });

    try testing.expectEqualSlices(u8, output_buf.items, result_buf.items);
}

fn createTmpFiles(allocator: std.mem.Allocator, contents: []const []const u8) ![]Tmp.TmpFile {
    var tmp_dir = try Tmp.tmpDir(.{});
    errdefer tmp_dir.cleanup();
    const tmp_files: []Tmp.TmpFile = try allocator.alloc(Tmp.TmpFile, contents.len);
    errdefer allocator.free(tmp_files);
    for (0..contents.len) |i| {
        tmp_files[i] = try Tmp.tmpFile(.{ .tmp_dir = tmp_dir });
        errdefer tmp_files[i].deinit();
        try tmp_files[i].f.writeAll(contents[i]);
    }
    return tmp_files;
}

const Tmp = struct {
    const random_bytes_count = 12;
    const random_path_len = std.fs.base64_encoder.calcSize(random_bytes_count);

    pub const TmpDir = struct {
        allocator: std.mem.Allocator,
        parent_dir_path: []const u8,
        sub_path: []const u8,
        parent_dir: std.fs.Dir,
        dir: std.fs.Dir,

        pub fn cleanup(self: *TmpDir) void {
            self.dir.close();
            self.parent_dir.deleteTree(self.sub_path) catch {};
            self.parent_dir.close();
            self.allocator.free(self.parent_dir_path);
            self.allocator.free(self.sub_path);
            self.* = undefined;
        }
    };

    pub const TmpFile = struct {
        allocator: std.mem.Allocator,
        tmp_dir: TmpDir,
        sub_path: []const u8,
        f: std.fs.File,

        /// caution: this deinit only clears mem resources, will not close file or delete tmp files & tmp_dir
        /// need manually close file, and clean them with tmp_dir
        pub fn deinit(self: *TmpFile) void {
            self.allocator.free(self.sub_path);
        }
    };

    fn getSysTmpDir(allocator: std.mem.Allocator) ![]const u8 {
        // cpp17's temp_directory_path gives good reference
        // https://en.cppreference.com/w/cpp/filesystem/temp_directory_path
        switch (builtin.os.tag) {
            .linux, .macos => {
                // POSIX standard, https://en.wikipedia.org/wiki/TMPDIR
                return std.process.getEnvVarOwned(allocator, "TMPDIR") catch {
                    return std.process.getEnvVarOwned(allocator, "TMP") catch {
                        return std.process.getEnvVarOwned(allocator, "TEMP") catch {
                            return std.process.getEnvVarOwned(allocator, "TEMPDIR") catch {
                                std.debug.print("tried env TMPDIR/TMP/TEMP/TEMPDIR but not found, fallback to /tmp, caution it may not work!", .{});
                                return try allocator.dupe(u8, "/tmp");
                            };
                        };
                    };
                };
            },
            .windows => {
                // should use GetTempPath2W, https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-gettemppath2w
                @compileError("TODO!");
            },
            else => {
                @panic("Not support, os=" ++ @tagName(std.builtin.os.tag));
            },
        }
    }

    fn tmpDir(args: struct {
        prefix: ?[]const u8 = null,
        opts: std.fs.Dir.OpenDirOptions = .{},
    }) !TmpDir {
        const allocator = std.heap.page_allocator;

        var random_bytes: [Tmp.random_bytes_count]u8 = undefined;
        std.crypto.random.bytes(&random_bytes);
        var random_path: [Tmp.random_path_len]u8 = undefined;
        _ = std.fs.base64_encoder.encode(&random_path, &random_bytes);

        const sys_tmp_dir_path = try getSysTmpDir(allocator);
        var sys_tmp_dir = try std.fs.openDirAbsolute(sys_tmp_dir_path, .{});

        var path_buf = std.ArrayList(u8).init(allocator);
        defer path_buf.deinit();

        try path_buf.writer().print("{s}_{s}", .{ if (args.prefix != null) args.prefix.? else "tmpdir", random_path });

        const tmp_dir = try sys_tmp_dir.makeOpenPath(path_buf.items, .{});

        return .{
            .allocator = allocator,
            .parent_dir_path = sys_tmp_dir_path,
            .sub_path = try path_buf.toOwnedSlice(),
            .parent_dir = sys_tmp_dir,
            .dir = tmp_dir,
        };
    }

    fn tmpFile(args: struct {
        tmp_dir: ?TmpDir = null,
        prefix: ?[]const u8 = null,
        dir_prefix: ?[]const u8 = null,
        flags: std.fs.File.CreateFlags = .{ .read = true },
        dir_opts: std.fs.Dir.OpenDirOptions = .{},
    }) !TmpFile {
        const tmp_dir = brk: {
            if (args.tmp_dir) |tmp_dir| {
                break :brk tmp_dir;
            } else {
                break :brk try tmpDir(.{ .prefix = args.dir_prefix, .opts = args.dir_opts });
            }
        };

        const allocator = tmp_dir.allocator;

        var random_bytes: [Tmp.random_bytes_count]u8 = undefined;
        std.crypto.random.bytes(&random_bytes);
        var random_path: [Tmp.random_path_len]u8 = undefined;
        _ = std.fs.base64_encoder.encode(&random_path, &random_bytes);

        var path_buf = std.ArrayList(u8).init(allocator);
        defer path_buf.deinit();

        try path_buf.writer().print("{s}_{s}", .{ if (args.prefix != null) args.prefix.? else "tmp", random_path });

        const tmp_file = try tmp_dir.dir.createFile(path_buf.items, args.flags);

        return .{
            .allocator = allocator,
            .tmp_dir = tmp_dir,
            .sub_path = try path_buf.toOwnedSlice(),
            .f = tmp_file,
        };
    }
};

test "Tmp" {
    var tmp_file = try Tmp.tmpFile(.{});
    defer {
        tmp_file.f.close();
        tmp_file.deinit();
        tmp_file.tmp_dir.cleanup();
    }
    try tmp_file.f.writeAll("hello, world!");

    try tmp_file.f.seekTo(0);
    var buf: [4096]u8 = undefined;
    const read_count = try tmp_file.f.readAll(&buf);
    try testing.expectEqual(read_count, "hello, world!".len);
    try testing.expectEqualSlices(u8, buf[0..read_count], "hello, world!");
}
