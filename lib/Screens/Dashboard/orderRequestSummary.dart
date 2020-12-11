import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Screens/Dashboard/paymentScreen.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatelessWidget {
  String itemDescription;
  String itemDescriptionImagePath;
  String receiverInfo;

  OrderSummary(
      {this.itemDescription, this.itemDescriptionImagePath, this.receiverInfo});

  String _directionInfo;
  var _chargeAmount;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;

    _directionInfo = Provider.of<AppData>(context).directionInfo != null
        ? Provider.of<AppData>(context).directionInfo.distanceText
        : "100KM";

    _chargeAmount = Provider.of<AppData>(context).directionInfo != null
        ? AssistantMethods.calculateFare(
            Provider.of<AppData>(context).directionInfo)
        : "5000";

    return Scaffold(
      floatingActionButton: Container(
        height: 60,
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentPage()));
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
                    buildContainerImage(''),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35,
                          ),
                          buildTitlenSubtitleText('Laptop', Colors.black, 16,
                              FontWeight.normal, TextAlign.start, null),
                          SizedBox(
                            height: 8,
                          ),
                          buildTitlenSubtitleText(
                              'Details of the laptop gotten from description',
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
                        buildContainerImage(''),
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
                                  'Uloho Jerome',
                                  Colors.black,
                                  16,
                                  FontWeight.normal,
                                  TextAlign.start,
                                  null),
                              SizedBox(
                                height: 8,
                              ),
                              buildTitlenSubtitleText(
                                  Provider.of<AppData>(context)
                                              .destinationLocation !=
                                          null
                                      ? Provider.of<AppData>(context)
                                          .destinationLocation
                                          .placeName
                                      : "unknown location",
                                  Colors.grey,
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
                      height: 50,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitlenSubtitleText('Warri', Colors.grey[500],
                                16, FontWeight.w700, TextAlign.start, null),
                            buildTitlenSubtitleText('Lagos', Colors.grey[500],
                                16, FontWeight.w700, TextAlign.start, null),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildDestinationTracker(context),
                      ],
                    ),
                    SizedBox(
                      height: 40,
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

  buildDestinationTracker(context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.height * 0.07,
          color: Colors.blue,
        ),
        Container(
          height: 25,
          width: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: getIcon(Icons.message, 10, Colors.white),
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.height * 0.07,
          color: Colors.grey[300],
        ),
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.height * 0.08,
          color: Colors.grey[300],
        ),
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
        ),
      ],
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

  statusWidget(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.blue : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
