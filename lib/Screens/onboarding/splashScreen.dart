import 'package:flutter/material.dart';
import 'package:fronto/Screens/onboarding/addPhoneNumber.dart';
import 'package:fronto/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  bool isFirstTime;

  SplashScreen({this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                if (isFirstTime) await saveFirstTime();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPhoneNumber()));
              },
              child: Container(
                height: 52,
                margin: EdgeInsets.only(
                  bottom: 120,
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
            ),
          ],
        ),
      ),
    );
  }

  saveFirstTime() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isFirstTime', true);
  }
}
