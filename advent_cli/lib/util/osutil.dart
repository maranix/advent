import "dart:io";

import "package:advent_cli/constants.dart";
import "package:path/path.dart" as path;

String? env(String key) => Platform.environment[key];

String requireEnv(String key) =>
    env(key) ?? (throw StateError("Env var $key is not available"));

String homeDir() => switch (Platform.operatingSystem) {
      "windows" => requireEnv(WINDOWS_HOME_ENV_KEY),
      "macos" => env(UNIX_XDG_ENV_KEY) ?? requireEnv(UNIX_HOME_ENV_KEY),
      "linux" => env(UNIX_XDG_ENV_KEY) ?? requireEnv(UNIX_HOME_ENV_KEY),
      _ => throw StateError("Platform is not supported"),
    };

String configDir() => switch (Platform.operatingSystem) {
      "windows" => path.join(homeDir()),
      "macos" => path.join(homeDir(), "Library", "Application Support"),
      "linux" => path.join(homeDir(), ".config"),
      _ => throw StateError("Platform is not supported"),
    };

String tmpDir() => switch (Platform.operatingSystem) {
      "windows" => requireEnv(WINDOWS_TMP_ENV_KEY),
      "macos" => path.join(UNIX_TMP_ENV_KEY),
      "linux" => path.join(UNIX_TMP_ENV_KEY),
      _ => throw StateError("Platform is not supported"),
    };

Directory applicationConfigDir() =>
    Directory(path.join(configDir(), APPLICATION_DIR_NAME));

Directory applicationTmpDir() =>
    Directory(path.join(tmpDir(), APPLICATION_DIR_NAME));
