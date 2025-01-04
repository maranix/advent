import "dart:io";
import "dart:typed_data";

import "package:advent_cli/constants.dart";
import "package:http/http.dart" as http;

final class WebClient {
  WebClient({
    required String cookie,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _cookie = cookie;

  final http.Client _client;

  final String _cookie;

  Future<Uint8List> getInput(int day, int year) async {
    final uri = Uri.parse(AOC_URL).replace(path: "$year/day/$day/input");

    final res = await _client.get(
      uri,
      headers: {
        HttpHeaders.cookieHeader: "session=$_cookie",
      },
    );

    if (res.statusCode != HttpStatus.ok) {
      throw HttpException(
        "Failed to fetch input $year $day: ${res.statusCode}",
        uri: uri,
      );
    }

    return res.bodyBytes;
  }

  void close() {
    _client.close();
  }
}
