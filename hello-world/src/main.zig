const std = @import("std");

pub fn main() !void {
    // 创建一个分配器
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // 目标 URL
    const url = "http://httpbin.org/get";

    // 手动提取主机名和路径
    const host_start = std.mem.indexOf(u8, url, "://").? + 3;
    const path_start = std.mem.indexOf(u8, url[host_start..], "/") orelse url.len;
    const host = url[host_start .. host_start + path_start];
    const path = url[host_start + path_start ..];

    // 解析域名
    const address = try resolveHostname(allocator, host, 80); // HTTP 默认端口是 80
    defer allocator.free(address);

    // 创建一个 TCP 连接
    var stream = try std.net.tcpConnectToAddress(address);
    defer stream.close();

    // 构造 HTTP GET 请求
    const request = try std.fmt.allocPrint(allocator, "GET {s} HTTP/1.1\r\nHost: {s}\r\nConnection: close\r\n\r\n", .{
        path,
        host,
    });
    defer allocator.free(request);

    // 发送请求
    try stream.writeAll(request);

    // 读取响应
    var buffer: [4096]u8 = undefined;
    const bytes_read = try stream.read(&buffer);
    const response = buffer[0..bytes_read];

    // 打印响应内容
    std.debug.print("Response: {s}\n", .{response});
}

// 解析域名
fn resolveHostname(allocator: std.mem.Allocator, hostname: []const u8, port: u16) !std.net.Address {
    // 手动为 hostname 添加空终止符
    const c_hostname = try allocator.alloc(u8, hostname.len + 1);
    defer allocator.free(c_hostname);

    // 使用索引遍历并复制字节
    var i: usize = 0;
    while (i < hostname.len) : (i += 1) {
        c_hostname[i] = hostname[i];
    }
    c_hostname[hostname.len] = 0; // 添加空终止符

    var hints: std.c.addrinfo = undefined;
    hints.family = 0; // AF_UNSPEC 的值为 0
    hints.socktype = 1; // SOCK_STREAM 的值为 1
    hints.protocol = 6; // IPPROTO_TCP 的值为 6

    var res: *std.c.addrinfo = undefined;
    const ret = std.c.getaddrinfo(@ptrCast([*:0]u8, c_hostname.ptr), null, &hints, &res);
    if (ret != 0) {
        return error.HostnameResolutionFailed;
    }
    defer std.c.freeaddrinfo(res);

    const addr = res.addr;
    return switch (addr.family) {
        2 => std.net.Address.initIp4(addr.addr, port), // AF_INET 的值为 2
        10 => std.net.Address.initIp6(addr.addr, port, 0, 0), // AF_INET6 的值为 10
        else => error.UnsupportedAddressFamily,
    };
}
