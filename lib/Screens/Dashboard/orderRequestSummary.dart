import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Screens/Dashboard/paymentScreen.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/tripTracker.dart';
import 'package:fronto/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatefulWidget {
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  String _directionInfo;

  String _destinationState;

  String _pickUpState;

  String _receiverName;

  String _itemDescription;

  String _destinationLocation;

  String _pickUpLocation;

  File _itemImage;

  File _receiverImage;

  int _chargeAmount;

  bool isExpress = false;

  @override
  void initState() {
    super.initState();
    getCharge();
  }

  getCharge() {
    int charge = AssistantMethods.calculateFare(context,
        Provider.of<AppData>(context, listen: false).directionInfo, false);

    _chargeAmount = charge;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;

    _directionInfo =
        Provider.of<AppData>(context, listen: false).directionInfo != null
            ? Provider.of<AppData>(context, listen: false)
                .directionInfo
                .distanceText
            : "100KM";

    _destinationLocation =
        Provider.of<AppData>(context, listen: false).destinationLocation != null
            ? Provider.of<AppData>(context, listen: false)
                .destinationLocation
                .placeName
            : "unknown location";

    _pickUpLocation =
        Provider.of<AppData>(context, listen: false).pickUpLocation != null
            ? Provider.of<AppData>(context, listen: false)
                .pickUpLocation
                .placeName
            : "unknown location";

    _destinationState =
        Provider.of<AppData>(context, listen: false).destinationLocation != null
            ? Provider.of<AppData>(context, listen: false)
                .destinationLocation
                .stateName
            : "unknown location";

    _pickUpState =
        Provider.of<AppData>(context, listen: false).pickUpLocation != null
            ? Provider.of<AppData>(context, listen: false)
                .pickUpLocation
                .stateName
            : "unknown location";

    _receiverName =
        Provider.of<AppData>(context, listen: false).orderRequestInfo != null
            ? Provider.of<AppData>(context, listen: false)
                .orderRequestInfo
                .receiverInfo
            : "unknown location";

    _itemDescription =
        Provider.of<AppData>(context, listen: false).orderRequestInfo != null
            ? Provider.of<AppData>(context, listen: false)
                .orderRequestInfo
                .itemDescription
            : "unknown location";

    _itemImage =
        Provider.of<AppData>(context, listen: false).orderRequestInfo != null
            ? Provider.of<AppData>(context, listen: false)
                .orderRequestInfo
                .itemImage
            : "unknown location";

    _receiverImage =
        Provider.of<AppData>(context, listen: false).orderRequestInfo != null
            ? Provider.of<AppData>(context, listen: false)
                .orderRequestInfo
                .receiverImage
            : "unknown location";

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          _buildContainer(size, context),
          _buildPositioned(size, context),
        ],
      ),
    );
  }

  _buildContainer(double size, context) {
    return Container(
      height: size,
      padding: EdgeInsets.only(left: 40, right: 40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size * 0.09,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTitlenSubtitleText('Summary', Colors.black, 25,
                    FontWeight.bold, TextAlign.center, null),
              ],
            ),
            SizedBox(
              height: size * 0.07,
            ),
            buildTitlenSubtitleText('You\'re Sending ', Colors.black, 20,
                FontWeight.bold, TextAlign.start, null),
            SizedBox(
              height: 20,
            ),
            Card(
              shadowColor: kWhiteColor,
              color: kWhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, bottom: size * 0.03, top: size * 0.03),
                child: buildCustomListTile(
                    buildContainerImage(_itemImage, Colors.grey[400]),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitlenSubtitleText(
                              _itemDescription,
                              Colors.black,
                              16,
                              FontWeight.normal,
                              TextAlign.start,
                              null),
                          SizedBox(
                            height: 8,
                          ),
                          buildTitlenSubtitleText(
                              _pickUpLocation,
                              Colors.grey[500],
                              12,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.visible),
                        ],
                      ),
                    ),
                    null,
                    20,
                    false),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            buildTitlenSubtitleText('Receiver Details', Colors.black, 20,
                FontWeight.bold, TextAlign.start, null),
            SizedBox(
              height: 20,
            ),
            Card(
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, bottom: size * 0.02, top: size * 0.03),
                child: Column(
                  children: [
                    buildCustomListTile(
                        buildContainerImage(_receiverImage, Color(0xFF27AE60)),
                        Flexible(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTitlenSubtitleText(
                                  _receiverName,
                                  Colors.black,
                                  16,
                                  FontWeight.normal,
                                  TextAlign.start,
                                  null),
                              SizedBox(
                                height: 8,
                              ),
                              buildTitlenSubtitleText(
                                  _destinationLocation,
                                  Colors.grey[500],
                                  12,
                                  FontWeight.normal,
                                  TextAlign.start,
                                  TextOverflow.visible),
                            ],
                          ),
                        ),
                        null,
                        20,
                        false),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [


                            buildTitlenSubtitleText(
                                _pickUpState,
                                Colors.grey[500],
                                16,
                                FontWeight.w700,
                                TextAlign.start,
                                null),


                            buildTitlenSubtitleText(
                                _destinationState,
                                Colors.grey[500],
                                16,
                                FontWeight.w700,
                                TextAlign.start,
                                null),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildDestinationTracker(context, 1),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: buildSubmitButton('EDIT INFORMATION', 5.0, true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            buildTitlenSubtitleText('Delivery Method', Colors.black, 18,
                FontWeight.bold, TextAlign.start, null),
            SizedBox(
              height: 20,
            ),
            Card(
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.only(
                    top: size * 0.025,
                    left: 20,
                    right: 20,
                    bottom: size * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitlenSubtitleText(
                            'Express Delivery',
                            Colors.black,
                            14,
                            FontWeight.bold,
                            TextAlign.start,
                            null),
                        SizedBox(
                          height: 5,
                        ),
                        buildTitlenSubtitleText(
                            'Get deliveries faster',
                            Colors.grey[500],
                            12,
                            FontWeight.normal,
                            TextAlign.start,
                            null),
                      ],
                    ),
                    Switch(
                      value: isExpress,
                      onChanged: (val) {
                        setState(() {
                          isExpress = val;
                        });
                        if (isExpress) {
                          setState(() {
                            _chargeAmount = AssistantMethods.calculateFare(
                                context,
                                Provider.of<AppData>(context, listen: false)
                                    .directionInfo,
                                true);
                          });
                        } else {
                          setState(() {
                            _chargeAmount = AssistantMethods.calculateFare(
                                context,
                                Provider.of<AppData>(context, listen: false)
                                    .directionInfo,
                                false);
                          });
                        }
                      },
                      activeColor: kWhiteColor,
                      activeTrackColor: kPrimaryColor,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            buildTitlenSubtitleText('Cost', Colors.black, 18, FontWeight.bold,
                TextAlign.start, null),
            SizedBox(
              height: 20,
            ),
            Card(
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.only(
                    top: size * 0.025,
                    left: 20,
                    right: 20,
                    bottom: size * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomListTile(
                      getIcon(Icons.location_on, 25, Colors.black),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitlenSubtitleText('Distance', Colors.grey[500],
                              12, FontWeight.normal, TextAlign.start, null),
                          SizedBox(
                            height: 5,
                          ),
                          buildTitlenSubtitleText(_directionInfo, Colors.black,
                              14, FontWeight.bold, TextAlign.start, null),
                        ],
                      ),
                      null,
                      10,
                      false,
                    ),
                    Container(
                      height: size * 0.075,
                      child: VerticalDivider(
                          color: Colors.grey[600], thickness: 1),
                    ),
                    buildCustomListTile(
                        getIcon(Icons.credit_card, 25, Colors.black),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitlenSubtitleText('Charge', Colors.grey[500],
                                12, FontWeight.normal, TextAlign.start, null),
                            SizedBox(
                              height: 5,
                            ),
                            buildTitlenSubtitleText(
                                '\u20A6 $_chargeAmount',
                                Colors.black,
                                14,
                                FontWeight.bold,
                                TextAlign.start,
                                null),
                          ],
                        ),
                        null,
                        10,
                        false),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              chargeAmount: _chargeAmount,
                              type: 'pay',
                            )));
              },
              child: buildSubmitButton('SEND PICK-UP REQUEST', 25.0, false),
            ),
            SizedBox(
              height: size * 0.03,
            ),
          ],
        ),
      ),
    );
  }

  _buildPositioned(double size, context) {
    return Positioned(
      top: size * 0.07,
      left: 10.0,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Material(
          elevation: 8.0,
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                getIcon(LineAwesomeIcons.times, 25, Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
