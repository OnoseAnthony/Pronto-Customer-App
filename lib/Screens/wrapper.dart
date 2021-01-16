import 'package:flutter/material.dart';
import 'package:fronto/Screens/Dashboard/locationHandler.dart';
import 'package:fronto/Screens/Onboarding/addPhoneNumber.dart';
import 'package:fronto/Services/firebase/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService().getCurrentUser();
    if (user == null) {
      return AddPhoneNumber();
    } else
      return LocationHandler();
  }
}
