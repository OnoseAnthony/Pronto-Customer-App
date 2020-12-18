import 'package:flutter/material.dart';
import 'package:fronto/Screens/Dashboard/homeScreen.dart';
import 'package:fronto/Screens/onboarding/splashScreen.dart';
import 'package:fronto/Services/firebase/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService().getCurrentUser();
    if (user == null)
      return SplashScreen();
    else
      return HomeScreen();
  }
}
