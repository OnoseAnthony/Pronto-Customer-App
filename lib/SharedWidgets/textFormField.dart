import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/Utils/cardInputFormatter.dart';
import 'package:fronto/Utils/cardValidators.dart';
import 'package:fronto/constants.dart';

buildPhoneNumberTextField(
    String hintText, TextEditingController controller, Widget prefixIcon) {
  return Container(
    child: TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (val) {},
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(10),
      ],
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}


buildEmailTextField(String hintText, TextEditingController controller,
    TextInputType textInputType) {
  return Container(
    child: TextFormField(
      minLines: textInputType == TextInputType.multiline ? 6 : null,
      // any number you need (It works as the rows for the textarea)
      maxLines: null,
      keyboardType: textInputType,
      onChanged: (val) {},
      controller: controller,
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

buildTextField(
    String hintText, TextEditingController controller, bool isReceiverNo) {
  String number;
  return Container(
    child: TextFormField(
      keyboardType: isReceiverNo ? TextInputType.number : TextInputType.text,
      onChanged: (val) {},
      controller: controller,
      validator: (val) => val.isEmpty && isReceiverNo && number != null
          ? null
          : val.isEmpty
              ? 'Field Cannot be empty'
              : null,
      inputFormatters: isReceiverNo
          ? [
              FilteringTextInputFormatter.digitsOnly,
              new LengthLimitingTextInputFormatter(11),
            ]
          : [],
      decoration: InputDecoration(
          suffixIcon: isReceiverNo
              ? InkWell(
                  onTap: () async {
                    final Contact contact =
                        await ContactPicker().selectContact();
                    controller.text = contact.phoneNumber.number;
                    number = contact.phoneNumber.number;
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                    ),
                    child: getIcon(Icons.person, 20, kWhiteColor),
                  ),
                )
              : null,
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.only(top: 15.0, bottom: 5.0)),
    ),
  );
}

buildNonEditTextField(String hintText, Function ontap) {
  return Container(
    child: TextFormField(
      onTap: ontap,
      readOnly: true,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.only(top: 12.0, bottom: 5.0)),
    ),
  );
}

buildCreditCardNumberField(TextEditingController controller, String hintText) {
  return TextFormField(
    onChanged: (val) {},
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      new LengthLimitingTextInputFormatter(19),
      new CardNumberInputFormatter()
    ],
    validator: validateCardNumWithLuhnAlgorithm,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 18),
      prefixIcon: getIcon(Icons.credit_card, 25, Colors.black),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
  );
}

buildCvvNumberField(TextEditingController controller, String hintText, context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.35,
    child: TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (val) {},
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(4),
      ],
      validator: validateCVV,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

buildExpiryNumberField(TextEditingController controller, String hintText,
    context) {
  return Container(
    width: MediaQuery
        .of(context)
        .size
        .width * 0.35,
    child: TextFormField(
      onChanged: (val) {},
      keyboardType: TextInputType.number,
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(4),
        new CardMonthInputFormatter()
      ],
      validator: validateDate,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 12
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

buildVerifyPhoneNumberField(TextEditingController controller,
    context) {
  return Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: kWhiteColor,
      borderRadius: BorderRadius.circular(3),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 0.25,
        )
      ],
    ),
    child: TextFormField(
      onChanged: (val) {},
      keyboardType: TextInputType.number,
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(1),
      ],
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15, bottom: 10),
        hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 12
        ),
        border: InputBorder.none,

      ),
    ),
  );
}
