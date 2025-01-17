import 'dart:convert';

import 'package:pickup_parent/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesService {
  static const String userKey = "user";
  static const String coinsKey = "coins";
  static const String userModel = "userModel";

  static final SharedPreferencesService _instance =
      SharedPreferencesService._();

  SharedPreferencesService._();

  factory SharedPreferencesService() {
    return _instance;
  }

  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  void saveBoolValue(String key, bool value) async {
    _prefs.setBool(key, value);
  }

  getBoolValue(String key) async {
    return _prefs.getBool(key) ?? false;
  }

  ///------------------Get User Object to preference

  UserModel? getUser() {
    if (_prefs.getString(userModel) != null) {
      Map<String, dynamic> userMap = jsonDecode(_prefs.getString(userModel)!);
      UserModel user =UserModel.fromJson(userMap);
      return user;
    }
    return null;
  }

  ///--------------------Save User Object to preference
  void saveUser(UserModel user) {
    _prefs.setString(userModel, jsonEncode(user.toMap()));
  }

  ///--------------------Clear User
  void clearUser() {
    _prefs.remove(userModel);
  }
}
