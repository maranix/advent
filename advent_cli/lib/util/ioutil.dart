import "dart:io";
import "package:path/path.dart" as p;

File createFile(String path, String name) {
  return File(p.join(path, name));
}

// TODO: Implement location and validation logic for Application Directory
String getApplicationDir() {
  return "";
}