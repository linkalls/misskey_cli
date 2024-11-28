import "package:dio/dio.dart";
import 'package:misskey_on_cli/gen/env.g.dart';

final env = Env.token;
final options = Options(headers: {
  //* 全部がdataにかけるわけじゃないので注意
  "Authorization": "Bearer $env",
  "Content-Type": "application/json",
  // "Content-Type": "multipart/form-data",
});
