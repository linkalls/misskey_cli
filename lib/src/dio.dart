import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Future<void> uploadFile() async {
  final dio = Dio();
  final filePath = 'C:/Users/nao03/Downloads/misskey_on_cli/lib/src/1049-200x300.jpg'; // アップロードするファイルのパス
  final serverUrl = 'http://localhost:8080/upload'; // サーバーのURL

  try {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        contentType: MediaType('multipart', 'form-data'), // コンテンツタイプを設定
      ),
    });

    final response = await dio.post(
      serverUrl,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200) {
      print('File uploaded successfully: ${response.data}');
    } else {
      print('Failed to upload file: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading file: $e');
  }
}

void main() {
  uploadFile();
}