import "package:advent_cli/web/server.dart";
import "package:args/command_runner.dart";

final class LoginCommand extends Command {
  @override
  String get name => "login";

  @override
  String get description => "Login to your Advent Of Code account.";

  @override
  Future<void> run() async {
    WebServer? server;

    try {
      server = await WebServer.serve();

      await server.statusStream.firstWhere(
        (status) => status == WebServerStatus.stopped,
      );

      print("Succesfully logged in");
    } on Exception catch (e) {
      print(e.toString());
    } finally {
      if (server != null) {
        server.dispose();
      }
    }
  }
}
