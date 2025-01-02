import "package:args/command_runner.dart";

final class GenCommand extends Command {
  GenCommand() {
    argParser.addOption("lang", abbr: "l");
    argParser.addOption("day", abbr: "d");
    argParser.addOption("year", abbr: "y");
  }

  @override
  String get name => "gen";

  @override
  String get description =>
      "Generates placeholder files for the given language, day & year.";

  @override
  void run() {
    if (argResults == null || argResults!.options.isEmpty) return;

    final args = argResults!;

    String lang = args.option("lang")!;
    int day = int.parse(args.option("day")!);
    int year = int.parse(args.option("year")!);

    print("$lang : $day, $year");
  }
}
