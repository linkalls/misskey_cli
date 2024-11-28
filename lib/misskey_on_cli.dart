library;

export 'src/misskey_on_cli_base.dart';

import "package:dio/dio.dart";
// import 'package:dotenv/dotenv.dart';
import 'package:misskey_on_cli/gen/env.g.dart';
import "dart:io";
import "package:misskey_on_cli/src/header.dart" as header;
import "package:misskey_on_cli/src/misskey_on_cli_base.dart";
import "package:args/args.dart";

void main(List<String> arguments) async {
  try {
    print("Hello, Misskey on CLI!");
    final parser = ArgParser();
    parser.addOption("file", abbr: "f");
    final results = parser.parse(arguments);

    final server = Env.server;
    final dio = Dio();
    if (arguments.length == 1) {
      //* textのみの投稿
      await dio.post("$server/api/notes/create",
          data: {
            "text": arguments[0],
          },
          options: header.options);
      print("Posted! ${arguments[0]}");
      // ここで終了の処理をしないと、プロセスが終了しない
      exit(0);
    } else if (arguments.length == 3) {
      //* textと画像の投稿
      final imagePath = results["file"];
      final fileId = await imageUrl(imagePath);
      await dio.post("$server/api/notes/create",
          data: {
            "text": arguments[0],
            "fileIds": [fileId],
          },
          options: header.options);
      print("Posted! ${arguments[0]} and $imagePath");
      exit(0);
    } else {
      print("Usage:  <text>");
      exit(1);
    }
  } catch (e) {
    print(e);
  }
}
