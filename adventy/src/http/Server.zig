const Self = @This();

const std = @import("std");

const mem = std.mem;
const net = std.net;
const log = std.log;
const http = std.http;

const logger = log.scoped(.HttpServer);

const DEFAULT_HOST = "127.0.0.1";
const DEFAULT_PORT = 7160;

pub const Options = struct {
    port: u16 = DEFAULT_PORT, // Unsigned 4 digits integer where each digit is of 4 bytes.
};

_server: net.Server,

pub fn init(options: Options) !Self {
    const addr = try net.Address.parseIp4(
        DEFAULT_HOST,
        options.port,
    );

    const server = try addr.listen(.{
        .reuse_address = true,
        .reuse_port = true,
    });

    return Self{ ._server = server };
}

pub fn start(self: *Self) !void {
    logger.info("Listening on http://{}", .{self._server.listen_address});

    while (true) {
        var conn = try self._server.accept();
        defer conn.stream.close();

        var read_buf: [1024]u8 = undefined;
        var http_server = http.Server.init(conn, &read_buf);

        var request = try http_server.receiveHead();

        try handle_request(&request);
    }
}

fn handle_request(request: *http.Server.Request) !void {
    // logger.info("Recevied request: {s}", .{request.head.target});

    request.respond("Acknowledged!", .{});
}

// pub fn stop(self: *self) !void {}
