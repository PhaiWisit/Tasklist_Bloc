import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_status.dart';

class SendOrder {
  static Future<Object> sendOrder(String orderText) async {
    // await dotenv.load(fileName: ".env");
    // String? lineApiKey = dotenv.get('LINE_API_KEY');
    String lineApiKey = 'DwxQPJYNbktpNHM4iouI7pqnWn2UYVvsS3bVF8eS4pu';
    String lineApiKey2 = 'XqKNsMvWv63pG3gseOK5IlB8svHiVjJ6kvAICST5Fml';

    try {
      var headers = {
        'Authorization': 'Bearer ${lineApiKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Access-Control-Allow-Origin': '*',
        // "Access-Control-Allow-Methods": "GET,POST,PUT",
        "Access-Control-Allow-Headers": "*",
        // "Access-Control-Allow-Credentials": 'true',
        // "Referrer-Policy": "no-referrer-when-downgrade",
        "X-Requested-With": "XMLHttpRequest",
        // "Accept": "*/*"
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://cors-anywhere.kawpun.com/notify-api.line.me:443/api/notify')); // ใช้ cors-anywhere.herokuapp แก้ปัญหาเฉพาะหน้าเกี่ยวกับ cors
      request.bodyFields = {'message': orderText};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (200 == response.statusCode) {
        return Success(code: 200, response: 'Success');
      } else {
        return Failure(code: 100, errorResponse: 'Invalid Response');
      }
    } on SocketException {
      return Failure(code: 101, errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(code: 102, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: 103, errorResponse: 'Unknown Error');
    }
  }
}
