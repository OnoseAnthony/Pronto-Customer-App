import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fronto/Utils/cardValidators.dart';

class CardAssistant {
  static Future<bool> chargeCard(
    BuildContext context,
    String reference,
    int price,
    String email,
    PaymentCard paymentCard,
  ) async {
    int amount = price * 100;
    var charge = Charge()
      ..amount = amount
      ..email = email
      ..reference = reference
      ..card = paymentCard;

    CheckoutResponse response = await PaystackPlugin.chargeCard(
      context,
      charge: charge,
    );

    if (response.status == true)
      return true;
    else if (response.status == false) return false;
  }
}

String getPaymentReference() {
  String platform;
  if (Platform.isIOS) {
    platform = 'iOS';
  } else {
    platform = 'Android';
  }
  return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
}

PaymentCard getCardFromSharedPreference(
    String expMonth, String expYear, String cardNumber, String cvv) {
  return PaymentCard(
    number: getCleanedNumber(cardNumber),
    cvc: cvv,
    expiryMonth: int.parse(expMonth),
    expiryYear: int.parse(expYear),
  );
}

PaymentCard getCardFromUI(TextEditingController _expDate,
    TextEditingController _cardNumber, TextEditingController _cvv) {
  List spiltDates = _expDate.text.split("/");
  return PaymentCard(
    number: getCleanedNumber(_cardNumber.text),
    cvc: _cvv.text,
    expiryMonth: int.parse(spiltDates[0]),
    expiryYear: int.parse(spiltDates[1]),
  );
}

handleBeforeValidate(Transaction transaction) {
  print(transaction.message);
}

