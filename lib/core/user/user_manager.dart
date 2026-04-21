import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager extends ChangeNotifier {
  String _name = "User Name";
  String _email = "user@example.com";
  String? _profilePic;

  String get name => _name;
  String get email => _email;
  String? get profilePic => _profilePic;

  UserManager() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? "User Name";
    _email = prefs.getString('user_email') ?? "user@example.com";
    _profilePic = prefs.getString('user_pic');
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required String email, String? pic}) async {
    final prefs = await SharedPreferences.getInstance();
    _name = name;
    _email = email;
    _profilePic = pic;
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    if (pic != null) await prefs.setString('user_pic', pic);
    notifyListeners();
  }
}
