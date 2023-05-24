import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/utils/logger.dart';

class UserNotifier extends ChangeNotifier {
  /*User? _user;

  User? get user => _user;

  UserNotifier() {
    initUser();
  }

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      logger.d("user - $user");
      notifyListeners();
    });
  }*/
}