import "package:advent_cli/cmd/cmd.dart";
import "package:args/command_runner.dart";

// Commands
//
// 1. gen (generate templates or directories for each year with support for language and individual day, year including bulk creation)
// 2. login (retreive a session token for fetching inputs (inputs should not be commited to github)
// 3. logout (delete session token)
// 4. config file for configuration & running the solutions via defined commands for each languages. (Handy, can be separeted and customized with .advent)
// 5. input (for getting input of specified year & day (current year & day by default)

const String version = "0.0.1";

CommandRunner buildRunner() {
  final runner = CommandRunner("advent", "");

  [
    LoginCommand(),
    LogoutCommand(),
    GenCommand(),
    InputCommand(),
    ConfigCommand()
  ].forEach(runner.addCommand);

  return runner;
}

void main(List<String> arguments) {
  final runner = buildRunner();

  runner.argParser.addFlag(
    "version",
    abbr: "v",
    negatable: false,
    help: "Show version.",
  );

  try {
    final results = runner.argParser.parse(arguments);

    if (results.flag("version")) {
      print("advent: $version");
      return;
    }

    runner.run(arguments);
  } on UsageException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print(runner.usage);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print(runner.usage);
  }
}
