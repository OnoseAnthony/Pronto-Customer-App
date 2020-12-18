import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Screens/Dashboard/paymentScreen.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/tripTracker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatelessWidget {


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

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;

    _directionInfo = Provider.of<AppData>(context).directionInfo != null
        ? Provider.of<AppData>(context).directionInfo.distanceText
        : "100KM";

    _chargeAmount = Provider.of<AppData>(context).directionInfo != null
        ? AssistantMethods.calculateFare(
            context, Provider.of<AppData>(context).directionInfo)
        : 5000;

    _destinationLocation =
        Provider.of<AppData>(context).destinationLocation != null
            ? Provider.of<AppData>(context).destinationLocation.placeName
            : "unknown location";

    _pickUpLocation = Provider.of<AppData>(context).pickUpLocation != null
        ? Provider.of<AppData>(context).pickUpLocation.placeName
        : "unknown location";

    _destinationState =
        Provider.of<AppData>(context).destinationLocation != null
            ? Provider.of<AppData>(context).destinationLocation.stateName
            : "unknown location";

    _pickUpState = Provider.of<AppData>(context).pickUpLocation != null
        ? Provider.of<AppData>(context).pickUpLocation.stateName
        : "unknown location";

    _receiverName = Provider.of<AppData>(context).orderRequestInfo != null
        ? Provider.of<AppData>(context).orderRequestInfo.receiverInfo
        : "unknown location";

    _itemDescription = Provider.of<AppData>(context).orderRequestInfo != null
        ? Provider.of<AppData>(context).orderRequestInfo.itemDescription
        : "unknown location";

    _itemImage = Provider.of<AppData>(context).orderRequestInfo != null
        ? Provider.of<AppData>(context).orderRequestInfo.itemImage
        : "unknown location";

    _receiverImage = Provider.of<AppData>(context).orderRequestInfo != null
        ? Provider.of<AppData>(context).orderRequestInfo.receiverImage
        : "unknown location";

    Provider.of<AppData>(context, listen: false)
        .updateChargeAmount(_chargeAmount);

    return Scaffold(
      floatingActionButton: Container(
        height: 60,
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaymentPage(
                            chargeAmount: _chargeAmount,
                            type: 'pay',
                          )));
            },
            backgroundColor: Colors.blue,
            elevation: 8,
            child: buildTitlenSubtitleText('Pay', Colors.white, 20,
                FontWeight.bold, TextAlign.center, null)),
      ),
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
              height: size * 0.16,
            ),
            buildTitlenSubtitleText('You\'re Sending ', Colors.black, 20,
                FontWeight.bold, TextAlign.start, null),
            SizedBox(
              height: 20,
            ),
            Card(
              shadowColor: Colors.white,
              color: Colors.white,
              borderOnForeground: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 10,
              child: Padding(
                padding:
                EdgeInsets.only(left: 20, right: 20, bottom: size * 0.05),
                child: buildCustomListTile(
                    buildContainerImage(_itemImage),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35,
                          ),
                          buildTitlenSubtitleText(
                              _itemDescription, Colors.black, 16,
                              FontWeight.normal, TextAlign.start, null),
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
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 8,
              child: Padding(
                padding:
                EdgeInsets.only(left: 20, right: 20, bottom: size * 0.04),
                child: Column(
                  children: [
                    buildCustomListTile(
                        buildContainerImage(_receiverImage),
                        Flexible(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),

                              buildTitlenSubtitleText(
                                  _receiverName, Colors.black, 16,
                                  FontWeight.normal, TextAlign.start, null),
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
                        buildDestinationTracker(context, 0),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    buildSubmitButton('EDIT INFORMATION', 5.0)
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
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.only(
                    top: size * 0.025,
                    left: 20,
                    right: 20,
                    bottom: size * 0.05),
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
                                _chargeAmount.toString(),
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
