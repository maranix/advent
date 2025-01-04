import "dart:io";

import "package:advent_cli/constants.dart";
import "package:advent_cli/util/apputil.dart" as apputil;
import "package:path/path.dart" as path;
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
      String token = "";

      final cwdPath = "./$SESSION_TOKEN_FILE_NAME";
      final configPath = path.join(
        apputil.applicationConfigDir().path,
        SESSION_TOKEN_FILE_NAME,
      );

      final sessionExists = await Future.wait(
        [
          Future<bool>.value(
              apputil.getSessionTokenFromEnv() == null ? false : true),
          FileSystemEntity.isFile(cwdPath),
          FileSystemEntity.isFile(configPath),
        ],
        eagerError: true,
      );

      for (final (i, exists) in sessionExists.indexed) {
        if (!exists) continue;

        if (i == 0) {
          token = apputil.getSessionTokenFromEnv() ?? "";
        } else if (i == 1) {
          token = await File(cwdPath).readAsString();
        } else {
          token = await File(configPath).readAsString();
        }
      }

      if (token.isEmpty) {
        print("Could not find session token");
        return;
      }

      final client = WebClient(cookie: token);
      final data = await client.getInput(day, year);
      client.close();

      final input = await File("./inputs/${year}_$day").create(recursive: true);
      await input.writeAsBytes(data, flush: true);

      print("Input $year $day saved under ./inputs directory");
    } on Exception catch (e) {
      print(e.toString());
      return;
    }
  }
}
