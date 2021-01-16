import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto/Screens/wrapper.dart';
import 'package:fronto/Services/firebase/pushNotificationService.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/constants.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  void initState() {
    super.initState();
    getNotificationService(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: kWhiteColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          'assets/images/getStarted.svg',
                          semanticsLabel: 'Get Started Logo',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 80, right: 80),
                        child: buildTitlenSubtitleText(
                            'Safe and secure delivery with Pronto \nLogistics.',
                            Color(0xFF555555),
                            12,
                            FontWeight.normal,
                            TextAlign.center,
                            null),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: buildSubmitButton('GET STARTED', 25.0, false),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getNotificationService(context) async {
    await NotificationService(context: context).initializeService();
    setState(() {});
  }
}
