import 'package:flutter/material.dart';
import 'package:fronto/Screens/onboarding/verifyPhoneNumber.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';

class AddPhoneNumber extends StatefulWidget {
  @override
  _AddPhoneNumberState createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends State<AddPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
                buildTitlenSubtitleText('Enter your number', Colors.black, 16,
                    FontWeight.w600, TextAlign.start, null),
                SizedBox(
                  height: 10,
                ),
                buildTitlenSubtitleText(
                    'We will send a code to verify your mobile number',
                    Colors.black54,
                    13,
                    FontWeight.normal,
                    TextAlign.start,
                    null),
                SizedBox(
                  height: 30,
                ),
                buildPhoneNumberTextField('Phone number', _controller),
                SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VerifyPhone()));
                  },
                  child: buildSubmitButton('NEXT', 25.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
