const std = @import("std");
const http = @import("http/http.zig");

pub fn main() !void {
    var server = try http.Server.init(.{});
    try server.start();
}
