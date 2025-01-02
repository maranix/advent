import "package:args/command_runner.dart";

final class ConfigCommand extends Command {
  @override
  String get name => "config";

  @override
  String get description =>
      "Configure modifiable options to customize the CLI.";

  @override
  void run() {
    print("Config");
  }
}
