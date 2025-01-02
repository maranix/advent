import "dart:io";

import "package:args/command_runner.dart";
import "package:shelf/shelf.dart";
import "package:shelf_router/shelf_router.dart";
import "package:shelf/shelf_io.dart" as shelf;

final class LoginCommand extends Command {
  @override
  String get name => "login";

  @override
  String get description => "Login to your Advent Of Code account.";

  @override
  Future<void> run() async {
    HttpServer? server;

    final app = Router();

    app.get("/login", (Request request) async {
      return Response.ok(
        """
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AOC Token</title>
</head>

<style>
    body {
        height: 100vh;
        width: 100%;
    }

    .flex--column--center {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }
</style>

<body class="flex--column--center">
    <h1>Submit your session token here!</h1>
    <form action="callback?" method="get">
        <input name="session" />
        <button>Submit</button>
    </form>
</body>

</html>
        """,
        headers: {
          HttpHeaders.contentTypeHeader: "text/html",
        },
      );
    });

    app.get("/callback", (Request request) async {
      if (!request.url.hasQuery) {
        return Response.badRequest(
          body: "Expected to receive query parameters.",
        );
      }

      final sessionToken = request.url.queryParameters["session"] ?? "";
      if (sessionToken.isEmpty) {
        return Response.badRequest(body: "Session token not found");
      }

      final file = File(".session");
      await file.writeAsString(
        sessionToken,
        mode: FileMode.writeOnly,
        flush: true,
      );

      if (server != null) {
        server.close();
      }

      return Response.ok("Close this page and continue via CLI.");
    });

    server = await shelf.serve(app.call, InternetAddress.loopbackIPv4, 8000);

    print("Listening on http://${server.address.host}:${server.port}");
  }
}
