import 'package:flutter/material.dart';
import 'package:fronto/Screens/Dashboard/homeScreen.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';

class AddEmailAddress extends StatefulWidget {
  @override
  _AddEmailAddressState createState() => _AddEmailAddressState();
}

class _AddEmailAddressState extends State<AddEmailAddress> {
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
                buildTitlenSubtitleText('Enter your Email Address',
                    Colors.black, 16, FontWeight.w600, TextAlign.start, null),
                SizedBox(
                  height: 40,
                ),
                buildEmailTextField('Email Address', _controller),
                SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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
