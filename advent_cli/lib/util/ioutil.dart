import "dart:io";
import "package:path/path.dart" as p;

File createFile(String path, String name) {
  return File(p.join(path, name));
}

String getApplicationDir() {}
