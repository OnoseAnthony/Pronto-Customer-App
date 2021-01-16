import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/cards.dart';
import 'package:fronto/Services/cardServices.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/Services/firebase/firestore.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/dialogs.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';
import 'package:fronto/Utils/cardValidators.dart';
import 'package:fronto/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  int chargeAmount;
  String type;

  PaymentPage({
    @required this.chargeAmount,
    @required this.type,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cardNumber = TextEditingController();
  TextEditingController _expDate = TextEditingController();
  TextEditingController _cvv = TextEditingController();
  bool loading = false;
  bool value = false;

  SharedPreferences sharedPreferences;
  List<CardDetails> cardList = List<CardDetails>();

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: kPaystackPublicKey);
    initSharedPreferences();
    super.initState();
  }

  @override
  void dispose() {
    _cardNumber.dispose();
    _expDate.dispose();
    _cvv.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    double widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(left: 40, right: 40),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size * 0.15,
                    ),
                    cardList.isNotEmpty
                        ? Container(
                            height: 140,
                            margin: EdgeInsets.only(bottom: 30),
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: cardList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return buildCardScrollView(
                                      widget.type == 'pay'
                                          ? 'assets/images/creditCardSkin.png'
                                          : 'assets/images/prontoCreditCardSkin.png',
                                      widthSize,
                                      cardList[index].cardNumber,
                                      cardList[index].cvv,
                                      cardList[index].expMonth,
                                      cardList[index].expYear,
                                      index);
                                }),
                          )
                        : SizedBox(),
                    buildCreditCardNumberField(_cardNumber, 'Card Number'),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildExpiryNumberField(_expDate, 'mm/yy', context),
                        buildCvvNumberField(_cvv, 'cvv', context),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    widget.type == 'pay'
                        ? Row(
                            children: [
                              Checkbox(
                                activeColor: kPrimaryColor,
                                checkColor: kWhiteColor,
                                value: value,
                                onChanged: (bool) {
                                  if (!value &&
                                      _formKey.currentState.validate()) {
                                    _showDialog(1);
                                  } else if (value) {
                                    setState(() {
                                      value = bool;
                                    });
                                  } else {
                                    showToast(
                                        context,
                                        'Please enter card information',
                                        kErrorColor,
                                        true);
                                  }
                                },
                              ),
                              buildTitlenSubtitleText(
                                  'Save card for future transactions',
                                  Colors.grey[500],
                                  13,
                                  FontWeight.normal,
                                  TextAlign.start,
                                  null),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () async {
                        switch (widget.type) {
                          case 'pay':
                            if (_formKey.currentState.validate() && !loading) {
                              setState(() {
                                loading = true;
                              });

                              if (value) {
                                List spiltDate = _expDate.text.split("/");
                                CardDetails cardDetails = CardDetails(
                                  cardNumber:
                                      getCleanedNumber(_cardNumber.text),
                                  cvv: _cvv.text,
                                  expMonth: spiltDate[0],
                                  expYear: spiltDate[1],
                                );

                                cardList.add(cardDetails);

                                saveCardDetails();
                              }

                              var reference = getPaymentReference();

                              bool response = await CardAssistant.chargeCard(
                                  context,
                                  reference,
                                  widget.chargeAmount,
                                  AuthService().getCurrentUser().email,
                                  getCardFromUI(_expDate, _cardNumber, _cvv));

                              if (response) {
                                Provider.of<AppData>(context, listen: false)
                                    .updatePaymentReference(reference);
                                Provider.of<AppData>(context, listen: false)
                                    .updatePaymentStatus('Successful');
                                Provider.of<AppData>(context, listen: false)
                                    .updateChargeAmount(widget.chargeAmount);
                                showToast(
                                    context,
                                    'Payment Successful. Processing Order...',
                                    kPrimaryColor,
                                    false);
                                await handleOnSuccess(context);
                              } else {
                                showToast(context, 'Payment Failed',
                                    kErrorColor, true);
                                handleOnError(context);
                              }

                              setState(() {
                                loading = false;
                              });
                            }
                            break;

                          case 'drawer':
                            if (_formKey.currentState.validate() && !loading) {
                              setState(() {
                                loading = true;
                              });

                              List spiltDate = _expDate.text.split("/");
                              CardDetails cardDetails = CardDetails(
                                cardNumber: getCleanedNumber(_cardNumber.text),
                                cvv: _cvv.text,
                                expMonth: spiltDate[0],
                                expYear: spiltDate[1],
                              );

                              cardList.add(cardDetails);

                              saveCardDetails();

                              _showMessage();

                              setState(() {
                                loading = false;
                              });

                              showToast(context, 'Card added successfully',
                                  kPrimaryColor, false);
                            }
                            break;
                        }
                      },
                      child: buildSubmitButton(
                          loading && widget.type == 'pay'
                              ? 'CHARGING'
                              : loading && widget.type == 'drawer'
                                  ? 'ADDING'
                                  : !loading && widget.type == 'pay'
                                      ? 'CHARGE CARD'
                                      : 'ADD CARD',
                          25.0,
                          false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: size * 0.07,
            left: 15.0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  getIcon(LineAwesomeIcons.times, 20, Colors.black),
                  SizedBox(
                    width: 25,
                  ),
                  buildTitlenSubtitleText('Payment', Colors.black, 18,
                      FontWeight.w600, TextAlign.start, null),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(int index) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return infoDialog(context, index);
      },
    );
  }

  Dialog infoDialog(contex, int index) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 5, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.info,
                color: kErrorColor,
                size: 60,
              ),
              SizedBox(height: 15),
              buildTitlenSubtitleText(
                  widget.type == 'pay'
                      ? 'NB: Your card details are not stored on our cloud database. '
                          'We securely store the card information on your smartphone device only.'
                      : 'Are you sure you want to delete this card information ?',
                  Colors.black,
                  12,
                  FontWeight.w600,
                  TextAlign.justify,
                  TextOverflow.visible),
              SizedBox(
                height: 10,
              ),
              widget.type == 'pay'
                  ? buildTitlenSubtitleText('Proceed?', Colors.black, 12,
                      FontWeight.w600, TextAlign.start, TextOverflow.visible)
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      textColor: kWhiteColor,
                      color: kPrimaryColor,
                      onPressed: () {
                        if (widget.type == 'pay') {
                          setState(() {
                            value = true;
                          });
                        } else {
                          cardList.removeAt(index);
                          saveCardDetails();

                          setState(() {});
                        }

                        Navigator.pop(context);
                        widget.type != 'pay'
                            ? showToast(context, 'Card removed successfully',
                                kPrimaryColor, false)
                            : showToast(context, 'Card Saved successfully',
                                kPrimaryColor, false);
                      },
                      child: Text(
                        'YES',
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                      textColor: kWhiteColor,
                      color: Colors.black54,
                      onPressed: () {
                        if (widget.type == 'pay') {
                          setState(() {
                            value = false;
                          });
                        }

                        Navigator.pop(context);
                      },
                      child: Text('NO')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCardScrollView(String assetPath, double size, String cardNumber,
      String cvv, String expMonth, String expYear, int index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(assetPath), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(5),
            color: Colors.black.withOpacity(0.7),
          ),
          height: 135,
          width: size * 0.65,
        ),
        Positioned(
            bottom: 25,
            right: 30,
            child: InkWell(
              onTap: () async {
                if (widget.type == 'pay') {
                  setState(() {
                    loading = true;
                  });

                  var reference = getPaymentReference();

                  bool response = await CardAssistant.chargeCard(
                    context,
                    reference,
                    widget.chargeAmount,
                    AuthService().getCurrentUser().email,
                    getCardFromSharedPreference(
                        expMonth, expYear, cardNumber, cvv),
                  );

                  if (response) {
                    Provider.of<AppData>(context, listen: false)
                        .updatePaymentReference(reference);
                    Provider.of<AppData>(context, listen: false)
                        .updatePaymentStatus('Successful');
                    Provider.of<AppData>(context, listen: false)
                        .updateChargeAmount(widget.chargeAmount);
                    showToast(
                        context,
                        'Payment Successful. Processing order...',
                        kPrimaryColor,
                        false);
                    await handleOnSuccess(context);
                  } else {
                    showToast(context, 'Payment Failed', kErrorColor, true);
                    handleOnError(context);
                  }

                  setState(() {
                    loading = false;
                  });
                } else {
                  _showDialog(index);
                }
              },
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: kWhiteColor,
                ),
                child: Center(
                  child: Text(
                    widget.type == 'pay' ? 'use card' : 'Delete card',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            )),
        Positioned(
          left: 30,
          top: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
              ),
              buildTitlenSubtitleText(
                  '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
                  kWhiteColor,
                  25,
                  FontWeight.normal,
                  TextAlign.start,
                  null),
              buildTitlenSubtitleText('${expMonth}/${expYear}', kWhiteColor, 16,
                  FontWeight.normal, TextAlign.start, TextOverflow.visible),
            ],
          ),
        ),
      ],
    );
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    retrieveCardDetails();
  }

  saveCardDetails() {
    List<String> strList =
        cardList.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('userCards', strList);
  }

  retrieveCardDetails() {
    List<String> strList = sharedPreferences.getStringList('userCards');
    if (strList != null) {
      cardList = strList
          .map((item) => CardDetails.fromMap(json.decode(item)))
          .toList();
      setState(() {});
    }
  }

  void _showMessage() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return successDialog(
          context,
        );
      },
    );
  }

  Dialog successDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 5, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.info,
                color: kErrorColor,
                size: 60,
              ),
              SizedBox(height: 15),
              buildTitlenSubtitleText('Card added succesfully', Colors.black,
                  12, FontWeight.w600, TextAlign.start, TextOverflow.visible),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                  textColor: kWhiteColor,
                  color: kPrimaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Proceed')),
            ],
          ),
        ),
      ),
    );
  }

  handleOnSuccess(context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return NavigationLoader(context);
      },
    );

    bool isSaved = await DatabaseService(firebaseUser: Provider
        .of<AppData>(context, listen: false)
        .firebaseUser, context: context).saveOrderRequest();

    if (isSaved) {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => completeDialog(context),
      );
    } else {
      Navigator.pop(context);
      showToast(context, 'we couldn\'t saved your order at this time.',
          kErrorColor, true);
    }
  }

  handleOnError(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(context);
      },
    );
  }
}
