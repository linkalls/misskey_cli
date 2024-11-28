library;

export 'src/misskey_on_cli_base.dart';

import "package:dio/dio.dart";
import 'package:dotenv/dotenv.dart';
import "dart:io";

void main(List<String> arguments) async {
  try {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final dio = Dio();
    if (arguments.length == 1) {
      await dio.post("https://misskey.io/api/notes/create",
          data: {
            "text": arguments[0],
          },
          options: Options(headers: {
            //* 全部がdataにかけるわけじゃないので注意
            "Authorization": "Bearer ${env["Token"]}",
            "Content-Type": "application/json",
          }));
      print("Posted! ${arguments[0]}");
      // ここで終了の処理をしないと、プロセスが終了しない
      exit(0);
    } else {
      print("Usage:  <text>");
      exit(1);
    }
  } catch (e) {
    print(e);
  }
}
