import "dart:io";

import "package:args/command_runner.dart";
import "package:advent_cli/constants.dart";
import "package:advent_cli/util/apputil.dart" as apputil;
import "package:path/path.dart" as path;

final class LogoutCommand extends Command {
  @override
  String get name => "logout";

  @override
  String get description => "Deletes the saved session token and logs out.";

  @override
  void run() async {
    final cwdPath = "./$SESSION_TOKEN_FILE_NAME";
    final configPath = path.join(
      apputil.applicationConfigDir().path,
      SESSION_TOKEN_FILE_NAME,
    );

    final sessionExists = await Future.wait(
      [
        FileSystemEntity.isFile(cwdPath),
        FileSystemEntity.isFile(configPath),
      ],
      eagerError: true,
    );

    try {
      for (final (i, exists) in sessionExists.indexed) {
        if (!exists) continue;

        if (i == 0) {
          await File(cwdPath).delete();
        } else {
          await File(configPath).delete();
        }
      }

      print("session token deleted");
    } on Exception catch (e) {
      print(e.toString());
      return;
    }
  }
}
