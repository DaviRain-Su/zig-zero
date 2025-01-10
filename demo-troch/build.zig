const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "demo-troch",
        .root_source_file = .{ .cwd_relative = "src/main.zig" }, // 使用 .cwd_relative 而不是 .path
        .target = target,
        .optimize = optimize,
    });

    // 添加 LibTorch 的头文件路径
    exe.addIncludePath(.{ .cwd_relative = "/Users/davirian/lib/libtorch/include" });
    exe.addIncludePath(.{ .cwd_relative = "/Users/davirian/lib/libtorch/include/torch/csrc/api/include" });
    exe.addIncludePath(.{ .cwd_relative = "." }); // 包含当前目录，确保找到 torch_wrapper.h

    // 添加 LibTorch 的库路径
    exe.addLibraryPath(.{ .cwd_relative = "/Users/davirian/lib/libtorch/lib" });
    exe.addLibraryPath(.{ .cwd_relative = "." }); // 包含当前目录，确保找到 libtorch_wrapper.so
    exe.linkSystemLibrary("torch_wrapper"); // 链接自定义的共享库

    // 链接 LibTorch 库
    exe.linkSystemLibrary("torch");
    exe.linkSystemLibrary("c10");

    // 安装可执行文件
    b.installArtifact(exe);

    // 添加运行步骤
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
