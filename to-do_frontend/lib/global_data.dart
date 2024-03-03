import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/repository/todo_repository.dart';
import 'package:to_do_app/repository/user_repository.dart';

class GlobalData {
  GlobalData();

  static String token = '';
  static SharedPreferences? prefs;
  static UserRepository userRepository = UserRepository();
  static ToDoRepository toDoRepository = ToDoRepository();
  static String currentUserName = 'John Doe';
  static String currentUserEmail = 'johndeo@exmample.com';
  static Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }
}