import "package:args/command_runner.dart";

final class InputCommand extends Command {
  InputCommand() {
    final date = DateTime.now();

    argParser.addOption(
      "day",
      abbr: "d",
      defaultsTo: date.day.toString(),
    );

    argParser.addOption(
      "year",
      abbr: "y",
      defaultsTo: date.year.toString(),
    );
  }

  @override
  String get name => "input";

  @override
  String get description => "Gets input for given day & year";

  @override
  void run() {
    if (argResults == null || argResults!.options.isEmpty) {
      printUsage();
      return;
    }

    final args = argResults!;

    int day = int.parse(args.option("day")!);
    int year = int.parse(args.option("year")!);

    print("$day : $year");
  }
}
