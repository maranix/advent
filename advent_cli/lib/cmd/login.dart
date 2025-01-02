import "package:args/command_runner.dart";

final class LoginCommand extends Command {
  @override
  String get name => "login";

  @override
  String get description => "Login to your Advent Of Code account.";

  @override
  void run() {
    // TODO: Start HttpServer
    print("Login");
  }
}
