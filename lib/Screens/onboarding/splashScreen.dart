import 'package:flutter/material.dart';
import 'package:fronto/Screens/onboarding/addPhoneNumber.dart';
import 'package:fronto/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    // ));
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPhoneNumber()));
            },
            child: Center(
              child: Container(
                height: 52,
                margin: EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: kContainerIconColor,
                ),
                child: Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

