const std = @import("std");
const add = @import("root.zig").add;
const MAX_POWER = @import("root.zig").MAX_POWER;

pub fn main() !void {
    const user = User{ .power = 100, .name = "davirian" };
    std.debug.print("User: {{ .power = {d}, .name = {s} }}\n", .{ user.power, user.name });

    const result = add(1, 2);
    std.debug.print("Result: {d}\n", .{result});

    std.debug.print("MAX_POWER: {d}\n", .{MAX_POWER});

    user.diagnose();

    const user1: User = .{
        .power = 9001,
        .name = "Goku",
    };

    user1.diagnose();

    const a = [5]i32{ 1, 2, 3, 4, 5 };
    const b: [5]i32 = .{ 5, 4, 3, 2, 1 };
    const c = [_]i32{ 1, 2, 3, 4, 5 };
    std.debug.print("a: {d}\n", .{a});
    std.debug.print("b: {d}\n", .{b});
    std.debug.print("c: {d}\n", .{c});

    const d = [5]i32{ 1, 2, 3, 4, 5 };
    var end: usize = 3;
    end += 1;
    const e = d[1..end];
    std.debug.print("e: {d}\n", .{e});
    std.debug.print("{any}\n", .{@TypeOf(e)});

    const f = d[1..];
    std.debug.print("f: {d}\n", .{f});
    std.debug.print("{any}\n", .{@TypeOf(f)});

    var g = [5]i32{ 1, 2, 3, 4, 5 };
    var end1: usize = 3;
    end1 += 1;
    const h = g[1..end1];
    g[2] = 99;
    std.debug.print("h: {d}\n", .{h});

    const bool_a = [3:false]bool{ false, true, false };
    std.debug.print("bool_a: {any}\n", .{bool_a});

    // This line is more advanced, and is not going to get explained!
    std.debug.print("{any}\n", .{std.mem.asBytes(&bool_a).*});

    std.debug.print("{any}\n", .{@TypeOf(.{ .year = 2023, .month = 8 })});

    const ret = anniversaryName(3);
    std.debug.print("Result: {s}\n", .{ret});

    const slice = [5]u32{ 1, 2, 3, 4, 5 };
    const ret1 = contains(&slice, 1); // change slice to &slice by adding & before slice
    std.debug.print("Result: {any}\n", .{ret1});

    for (0..4) |i| {
        std.debug.print("{d}\n", .{i});
    }

    const status = Status.OK;
    std.debug.print("Status: {s}\n", .{Status.toString(status)});
    std.debug.print("Status: {s}\n", .{Status.toString(Status.ERROR)});
    std.debug.print("Status is {s}\n", .{if (status.isOk()) "OK" else "ERROR"});

    const n = Number{ .nan = {} };
    std.debug.print("Number: {any}\n", .{n.nan});

    const ts = Timestamp{ .unix = 1693278411 };
    std.debug.print("{d}\n", .{ts.seconds()});

    const home: ?[]const u8 = null;
    const name: ?[]const u8 = "davirian";
    std.debug.print("home: {any}\n", .{home});
    std.debug.print("name: {s}\n", .{name.?});
    const home1 = home orelse "unknown";
    std.debug.print("home: {s}\n", .{home1});

    var pseudo_uuid: [16]u8 = undefined;
    std.debug.print("before pseudo_uuid: {any}\n", .{pseudo_uuid});
    std.crypto.random.bytes(&pseudo_uuid);
    std.debug.print("after pseudo_uuid: {any}\n", .{pseudo_uuid});

    const err = OpenError.FileNotFound;
    std.debug.print("error: {any}\n", .{err});
}

pub const OpenError = error{
    FileNotFound,
    PermissionDenied,
};

pub const User = struct {
    power: u64,
    name: []const u8,

    pub fn init(name: []const u8, power: u64) User {
        return .{ .name = name, .power = power };
    }

    pub const SUPER_POWER = 1000;

    pub fn diagnose(user: User) void {
        if (user.power >= SUPER_POWER) {
            std.debug.print("User {s} has super power\n", .{user.name});
        } else {
            std.debug.print("User {s} has normal power\n", .{user.name});
        }
    }
};

fn anniversaryName(years_married: u16) []const u8 {
    switch (years_married) {
        1 => return "paper",
        2 => return "cotton",
        3 => return "leather",
        4 => return "fruit or flowers",
        5 => return "wood",
        6 => return "candy or iron",
        else => return "not implemented",
    }
}

fn arrivalTimeDesc(minutes: u16, is_late: bool) []const u8 {
    switch (minutes) {
        0 => return "arrived",
        1, 2 => return "soon",
        3...5 => return "no more than 5 minutes",
        else => {
            if (!is_late) {
                return "sorry, it'll be a while";
            }
            // todo, something is very wrong
            return "never";
        },
    }
}

fn contains(haystack: []const u32, needle: u32) bool {
    for (haystack) |item| {
        if (item == needle) {
            return true;
        }
    }
    return false;
}

pub fn eql(comptime T: type, a: []const T, b: []const T) bool {
    // if they aren't the same length, they can't be equal
    if (a.len != b.len) return false;

    for (a, b) |a_elem, b_elem| {
        if (a_elem != b_elem) return false;
    }

    return true;
}

fn indexOf(haystack: []const u32, needle: u32) ?usize {
    for (haystack, 0..) |value, i| {
        if (needle == value) {
            return i;
        }
    }
    return null;
}

pub const Status = enum {
    OK,
    ERROR,

    pub fn toString(self: Status) []const u8 {
        switch (self) {
            .OK => return "OK",
            .ERROR => return "ERROR",
        }
    }

    pub fn isOk(self: Status) bool {
        return self == .OK;
    }

    pub fn isError(self: Status) bool {
        return self == .ERROR;
    }
};

pub const Number = union {
    int: i64,
    float: f64,
    nan: void,
};

const TimestampType = enum {
    unix,
    datetime,
};

const Timestamp = union(enum) {
    unix: i32,
    datetime: DateTime,

    const DateTime = struct {
        year: u16,
        month: u8,
        day: u8,
        hour: u8,
        minute: u8,
        second: u8,
    };

    fn seconds(self: Timestamp) u16 {
        switch (self) {
            .datetime => |dt| return dt.second,
            .unix => |ts| {
                const seconds_since_midnight: i32 = @rem(ts, 86400);
                return @intCast(@rem(seconds_since_midnight, 60));
            },
        }
    }
};
