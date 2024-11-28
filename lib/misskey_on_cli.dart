library;

export 'src/misskey_on_cli_base.dart';

import "package:dio/dio.dart";
// import 'package:dotenv/dotenv.dart';
import 'package:misskey_on_cli/gen/env.g.dart';
import "dart:io";

void main(List<String> arguments) async {
  try {
    final env = Env.token;
    final server = Env.server;
    final dio = Dio();
    if (arguments.length == 1) {
      await dio.post("${server}/api/notes/create",
          data: {
            "text": arguments[0],
          },
          options: Options(headers: {
            //* 全部がdataにかけるわけじゃないので注意
            "Authorization": "Bearer ${env}",
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
