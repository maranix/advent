import "dart:io";

import "package:advent_cli/constants.dart";
import "package:advent_cli/util/osutil.dart" as os;
import "package:path/path.dart" as p;

Directory applicationConfigDir() =>
    Directory(p.join(os.configDir(), APPLICATION_DIR_NAME));

Directory applicationTmpDir() =>
    Directory(p.join(os.tmpDir(), APPLICATION_DIR_NAME));
