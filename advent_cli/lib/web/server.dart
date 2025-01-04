import "dart:async";
import "dart:io";

import "package:advent_cli/constants.dart";
import "package:advent_cli/util/ioutil.dart" as ioutil;
import "package:advent_cli/util/apputil.dart" as apputil;
import "package:shelf/shelf.dart";
import "package:shelf_router/shelf_router.dart";
import "package:shelf/shelf_io.dart" as shelf;

part "index_html.dart";

enum WebServerStatus {
  starting,
  running,
  stopping,
  stopped,
}

final class WebServer {
  WebServer._();

  late final HttpServer _server;

  late final Router _router;

  final StreamController<WebServerStatus> _statusStreamController =
      StreamController<WebServerStatus>();

  WebServerStatus _serverStatus = WebServerStatus.starting;

  Stream<WebServerStatus> get statusStream => _statusStreamController.stream;

  static Future<WebServer> serve({int port = 8000, dynamic address}) async {
    final instance = WebServer._();

    instance._router = Router();
    instance._registerRoutes();

    instance._server = await shelf.serve(
      instance._router.call,
      address ?? InternetAddress.loopbackIPv4,
      port,
    );

    instance._listenForTerminationSignal();
    print(
        "Listening on http://${instance._server.address.host}:${instance._server.port}");

    instance._updateServerStatus(WebServerStatus.running);

    return instance;
  }

  void _updateServerStatus(WebServerStatus status) {
    _serverStatus = status;
    _statusStreamController.add(status);
  }

  Future<void> stop() async {
    if (_serverStatus != WebServerStatus.running) {
      throw StateError("Server is not currently running.");
    }

    _updateServerStatus(WebServerStatus.stopping);
    await _server.close();
    _updateServerStatus(WebServerStatus.stopped);
  }

  Future<void> dispose() async {
    await _statusStreamController.close();
  }

  void _registerRoutes() {
    _router.get("/login", _handleLogin);
    _router.get("/callback", _handleCallback);
  }

  Future<Response> _handleLogin(Request request) async {
    return Response.ok(
      _indexHtml,
      headers: {
        HttpHeaders.contentTypeHeader: "text/html",
      },
    );
  }

  Future<Response> _handleCallback(Request request) async {
    if (!request.url.hasQuery) {
      return Response.badRequest(
        body: "Expected to receive query parameters.",
      );
    }

    final sessionToken = request.url.queryParameters["session"] ?? "";
    if (sessionToken.isEmpty) {
      return Response.badRequest(body: "Session token not found");
    }

    final file = ioutil.createFile(
        apputil.applicationConfigDir().path, SESSION_TOKEN_FILE_NAME);
    await file.writeAsString(
      sessionToken,
      mode: FileMode.writeOnly,
      flush: true,
    );

    await stop();

    print("Succesfully logged in");
    return Response.ok(
        "Token Received!, you can close this page and continue via CLI.");
  }

  void _listenForTerminationSignal() {
    ProcessSignal.sigint.watch().take(1).listen((_) async {
      print("\nProcess termination requested, stopping server...");
      await stop();
    });
  }
}
