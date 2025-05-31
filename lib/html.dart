import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

post(String url, body) async {
  try {
    Response response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);

      return responsebody;
    } else {
      return 'wrong';
    }
  } on Exception {
    return 'wrong';
  }
}

getnames(String url) async {
  try {
    Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);
      return responsebody;
    } else {
      return response.body;
    }
  } on Exception catch (e) {
    print(e);
  }
}
