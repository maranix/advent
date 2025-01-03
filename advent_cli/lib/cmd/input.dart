import "dart:io";

import "package:advent_cli/web/client.dart";
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
  void run() async {
    if (argResults == null || argResults!.options.isEmpty) {
      printUsage();
      return;
    }

    final args = argResults!;

    int day = int.parse(args.option("day")!);
    int year = int.parse(args.option("year")!);

    try {
      final session = await File(".session").readAsString();
      final client = WebClient(cookie: session);

      final data = await client.getInput(day, year);

      final input = File("${year}_$day");
      await input.writeAsBytes(data, flush: true);
    } on Exception catch (e) {
      print(e.toString());
      return;
    }
  }
}
