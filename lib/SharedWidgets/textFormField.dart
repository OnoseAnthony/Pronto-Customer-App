import 'package:flutter/material.dart';
import 'package:fronto/SharedWidgets/buttons.dart';

buildTextField(String hintText, TextEditingController controller) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: TextFormField(
      onChanged: (val) {},
      controller: controller,
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
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(3.0),
      border: Border.all(color: Colors.black26),
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 6.0,
          spreadRadius: 0.5,
          offset: Offset(0.7, 0.7),
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        onChanged: (val) {},
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: getIcon(Icons.search, 14, Colors.black26),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[200],
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0)),
      ),
    ),
  );
}

buildCvvNumberField(TextEditingController controller, String hintText) {
  return Container(
    width: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(3.0),
      border: Border.all(color: Colors.black26),
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 6.0,
          spreadRadius: 0.5,
          offset: Offset(0.7, 0.7),
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        onChanged: (val) {},
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: getIcon(Icons.search, 14, Colors.black26),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[200],
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0)),
      ),
    ),
  );
}

buildExpiryNumberField(TextEditingController controller, String hintText) {
  return Container(
    width: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(3.0),
      border: Border.all(color: Colors.black26),
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 6.0,
          spreadRadius: 0.5,
          offset: Offset(0.7, 0.7),
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        onChanged: (val) {},
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: getIcon(Icons.search, 14, Colors.black26),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[200],
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0)),
      ),
    ),
  );
}
