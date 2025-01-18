const std = @import("std");
const expect = std.testing.expect;

test "always succeeds" {
    try expect(true);
}

//test "always fails" {
//try expect(false);
//}

// if expression

test "if expression" {
    const a = 1;
    const b = 2;
    const c = if (a == b) 1 else 2;
    try expect(c == 2);
}

test "if statement" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    try expect(x == 1);
}

test "if statement expression" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}

// while loops

// without a continue expression
test "while" {
    var i: u8 = 2;
    while (i < 100) {
        i *= 2;
    }
    try expect(i == 128);
}

// with a continue expression

test "while with continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        sum += i;
    }
    try expect(sum == 55);
}

// with a continue
test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) {
            continue;
        }
        sum += i;
    }
    try expect(sum == 4);
}

// with a break
test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) {
            break;
        }
        sum += i;
    }
    try expect(sum == 1);
}

// for loops

test "for" {
    // character literals are equivalent to integer literals
    const string = [_]u8{ 'h', 'e', 'l', 'l', 'o' };

    for (string, 0..) |character, index| {
        //std.debug.print("index: {d} - {c}\n", .{ index, character });
        _ = character;
        _ = index;
    }

    for (string) |character| {
        _ = character;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}

fn addFive(x: u32) u32 {
    return x + 5;
}

test "function" {
    const y = addFive(5);
    try expect(@TypeOf(y) == u32);
    try expect(y == 10);
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    const y = fibonacci(10);
    try expect(y == 55);
}

// defer
//
test "defer" {
    var x: i16 = 5;
    {
        defer x += 1;
        try expect(x == 5);
    }
    try expect(x == 6);
}

test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    try expect(x == 4.5);
}

const Place = struct {
    lat: f32,
    long: f32,

    fn display(self: Place) void {
        std.debug.print("lat: {d}\n", .{self.lat});
        std.debug.print("long: {d}\n", .{self.long});
    }
};

// json parse
test "json parse" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const test_allocator = gpa.allocator();

    const parsed = try std.json.parseFromSlice(
        Place,
        test_allocator,
        \\{ "lat": 40.684540, "long": -74.401422 }
    ,
        .{},
    );
    defer parsed.deinit();

    const place = parsed.value;
    //place.display();
    try expect(place.lat == 40.684540);
    try expect(place.long == -74.401422);
}

const Vec3 = struct { x: f32, y: f32, z: f32 };

test "struct usage" {
    const v = Vec3{ .x = 1.0, .y = 2.0, .z = 3.0 };
    try expect(v.x == 1.0);
    try expect(v.y == 2.0);
    try expect(v.z == 3.0);
}

const Vec4 = struct { x: f32 = 0, y: f32 = 0, z: f32 = 0, w: f32 = 0 };

test "struct default values" {
    const v = Vec4{ .x = 1.0, .y = 2.0, .z = 3.0 };
    try expect(v.x == 1.0);
    try expect(v.y == 2.0);
    try expect(v.z == 3.0);
    try expect(v.w == 0.0);
}

const Stuff = struct {
    x: i32,
    y: i32,

    fn swap(self: *Stuff) void {
        const temp = self.x;
        self.x = self.y;
        self.y = temp;
    }
};

test "automatic dereference" {
    var stuff = Stuff{ .x = 1, .y = 2 };
    stuff.swap(); //Stuff.swap(&stuff); same as this
    try expect(stuff.x == 2);
    try expect(stuff.y == 1);
}

fn increment(x: *u8) void {
    x.* += 1;
}

test "pointer dereference" {
    var x: u8 = 5;
    increment(&x);
    try expect(x == 6);
}

test "naughty pointer" {
    var x: u16 = 5;
    x -= 5;
    //var y: *u8 = @ptrFromInt(x);
    //y = y; // this is naughty
}

test "const pointers" {
    // const x: u8 = 5; change before
    // change after
    var x: u8 = 5;
    const y = &x;
    y.* += 1;

    try expect(x == 6);
}

test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(usize) == @sizeOf(*u16));
    try expect(@sizeOf(isize) == @sizeOf(*u32));

    std.debug.print("usize: {d}\n", .{@sizeOf(usize)});
    std.debug.print("u8 size: {d}\n", .{@sizeOf(u8)});
    std.debug.print("u16 size: {d}\n", .{@sizeOf(u16)});
    std.debug.print("u32 size: {d}\n", .{@sizeOf(u32)});
    std.debug.print("u64 size: {d}\n", .{@sizeOf(u64)});
    std.debug.print("u128 size: {d}\n", .{@sizeOf(u128)});
    std.debug.print("u256 size: {d}\n", .{@sizeOf(u256)});
    std.debug.print("u512 size: {d}\n", .{@sizeOf(u512)});
    std.debug.print("u1024 size: {d}\n", .{@sizeOf(u1024)});
    std.debug.print("u2048 size: {d}\n", .{@sizeOf(u2048)});
    std.debug.print("u4096 size: {d}\n", .{@sizeOf(u4096)});
}
