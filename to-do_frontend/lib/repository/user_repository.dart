import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/config.dart';
import 'package:to_do_app/global_data.dart';

class UserRepository {
  UserRepository();

  Future<bool> registerUser(var reqBody) async {
    try {
      var response = await http.post(Uri.parse(registration), headers: GlobalData.getHeaders(), body: jsonEncode(reqBody));
      switch (response.statusCode) {
        case 200:
          var jsonResponse = jsonDecode(response.body);
          return jsonResponse['status'];
        default:
          return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  Future<bool> loginUser(var reqBody) async {
    try {
      var response = await http.post(Uri.parse(login), headers: GlobalData.getHeaders(), body: jsonEncode(reqBody));
      switch (response.statusCode) {
        case 201:
          var jsonResponse = jsonDecode(response.body);
          GlobalData.token = jsonResponse['token'];
          GlobalData.prefs?.setString('token', GlobalData.token);
          return jsonResponse['status'];
        default:
          return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }
}
