const std = @import("std");

const c = @cImport({
    @cInclude("torch_wrapper.h"); // 包含 C 头文件
});

pub fn main() void {
    std.debug.print("Calling PyTorch C++ API from Zig\n", .{});

    // 创建张量
    const tensor_ptr = c.create_tensor();
    defer c.free_tensor(tensor_ptr); // 确保释放张量

    // 打印张量
    c.print_tensor(tensor_ptr);
}
