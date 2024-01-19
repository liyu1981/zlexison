const std = @import("std");

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

export fn hello() ?[]u8 {
    var hello_str = "hello";
    const str = std.heap.page_allocator.alloc(u8, hello_str.len) catch return null;
    @memcpy(str, &hello_str);
    return str;
}

export fn freeStr(target_str: [*c]const u8) void {
    std.heap.page_allocator.free(target_str);
}
