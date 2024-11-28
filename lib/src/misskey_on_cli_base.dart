import "package:dio/dio.dart";
import 'package:misskey_on_cli/gen/env.g.dart';
import "package:http_parser/http_parser.dart";

Future<dynamic> imageUrl(String imagePath) async {
  final server = Env.server;
  final token = Env.token; // トークンを取得
  final dio = Dio();

  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      imagePath,
      contentType: MediaType('multipart', 'form-data'), // コンテンツタイプを設定
    ),
  });
  try {
    final response = await dio.post<Map<String, dynamic>>(
      "$server/api/drive/files/create",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    print(response.data!["id"]);
    return response.data!["id"];
  } catch (e) {
    final ee = e;
    print((ee as Map)['message']);
  }
}

// void main() async {
//   await imageUrl();
// }
