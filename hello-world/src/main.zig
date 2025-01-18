const std = @import("std");

pub fn main() void {
    // "hello, world!" will be written to stderr, and it is assumed to never fail.
    std.debug.print("Hello, {s}!\n", .{"world"});

    // assignment
    std.debug.print("******************************************\n", .{});

    const constant: i32 = 42;
    var variable: i32 = 42;

    std.debug.print("constant: {d}\n", .{constant});
    std.debug.print("variable change before : {d}\n", .{variable});

    variable = 43;
    std.debug.print("variable change after : {d}\n", .{variable});

    std.debug.print("******************************************\n", .{});

    // @as performs as explicit type coercion
    const inferred_constant = @as(i32, 42);
    var inferred_variable = @as(i32, 42);
    std.debug.print("inferred_constant: {d}\n", .{inferred_constant});
    std.debug.print("inferred_variable change before : {d}\n", .{inferred_variable});

    inferred_variable = @as(i32, 43);
    std.debug.print("inferred_variable change after : {d}\n", .{inferred_variable});
    std.debug.print("******************************************\n", .{});

    // arrays
    const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
    const b = [_]u8{ 'w', 'o', 'r', 'l', 'd', '!' };
    std.debug.print("a: {s}\n", .{a});
    std.debug.print("b: {s}\n", .{b});
    std.debug.print("a len: {d}\n", .{a.len});
    std.debug.print("b len: {d}\n", .{b.len});
}
