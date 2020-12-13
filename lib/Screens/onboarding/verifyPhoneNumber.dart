import 'package:flutter/material.dart';
import 'package:fronto/Screens/onboarding/addEmailAddress.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';

class VerifyPhone extends StatefulWidget {
  String phoneNumber;

  VerifyPhone({this.phoneNumber});

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.07),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitlenSubtitleText('Enter code', Colors.black, 15,
                    FontWeight.bold, TextAlign.start, null),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    buildTitlenSubtitleText(
                        'An SMS code was sent to  ',
                        Colors.black26,
                        13,
                        FontWeight.normal,
                        TextAlign.start,
                        null),
                    buildTitlenSubtitleText('+234 9030846221', Colors.black, 15,
                        FontWeight.bold, TextAlign.start, null),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: buildTitlenSubtitleText(
                      'Edit phone number',
                      Colors.blue,
                      13,
                      FontWeight.normal,
                      TextAlign.start,
                      null),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildVerifyPhoneNumberField(_controller, context),
                    buildVerifyPhoneNumberField(_controller1, context),
                    buildVerifyPhoneNumberField(_controller2, context),
                    buildVerifyPhoneNumberField(_controller3, context),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEmailAddress()));
                  },
                  child: buildSubmitButton('NEXT', 25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
