const std = @import("std");

fn findRulePatternStop(line: []const u8) ?usize {
    var i: usize = 0;
    var inside_class_braket: bool = false;
    while (i < line.len) {
        if ((i + 1) < line.len and line[i] == '\\' and line[i + 1] == ' ') {
            i += 2;
            continue;
        }
        if (line[i] == '[') inside_class_braket = true;
        if (line[i] == ']') inside_class_braket = false;
        //std.debug.print("\ncheck {d}, {c}, {any}\n", .{ i, line[i], inside_class_braket });
        if (inside_class_braket and line[i] == ' ') {
            i += 1;
            continue;
        }
        if (line[i] == ' ' or line[i] == '\t') return i;
        i += 1;
    }
    return null;
}

test "findRulePatternStop" {
    try std.testing.expectEqual(findRulePatternStop(""), null);
    try std.testing.expectEqual(findRulePatternStop(" "), 0);
    try std.testing.expectEqual(findRulePatternStop("[ \\t] "), 5);
    try std.testing.expectEqual(findRulePatternStop("[s \\t] "), 6);
}
