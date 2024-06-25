import 'package:flutter/material.dart';
import 'package:students_app_provider/screens/home/home_list.dart';

class SplashProvider extends ChangeNotifier {
  Future<void> goToLogin(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => HomeList(),
      ),
    );
  }
}