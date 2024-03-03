import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/config.dart';
import 'package:to_do_app/global_data.dart';

class ToDoRepository {
  ToDoRepository();

  Future<List> getTodoList({String order = 'DESC', bool? isCompleted}) async {
    String queryParam = '?order=$order&';
    if(isCompleted != null) {
      queryParam += 'completed=$isCompleted';
    }
    try {
      var response = await http.get(Uri.parse(getToDoList+queryParam), headers: GlobalData.getHeaders());
      switch (response.statusCode) {
        case 200:
          var jsonResponse = jsonDecode(response.body);
          GlobalData.currentUserName = jsonResponse['name'];
          GlobalData.currentUserEmail = jsonResponse['email'];
          return jsonResponse['result'];
        default:
          return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }

  Future<bool> addTodo(var reqBody) async {
    try {
      var response = await http.post(Uri.parse(addtodo), headers: GlobalData.getHeaders(), body: jsonEncode(reqBody));
      switch (response.statusCode) {
        case 201:
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

  Future<bool> deleteItem({int? itemId}) async {
    try {
      var response = await http.delete(Uri.parse('$deleteTodo/$itemId'), headers: GlobalData.getHeaders());
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

  Future<bool> updateItem({int? itemId, var reqBody}) async {
    try {
      var response = await http.put(Uri.parse('$updateTodo/$itemId'), headers: GlobalData.getHeaders(), body: jsonEncode(reqBody));
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
}
