import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/address.dart';
import 'package:fronto/Services/requestAssistant.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/dialogs.dart';
import 'package:fronto/SharedWidgets/predictedAddressTile.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String destinatioHintText;
  String pickUpHintText;
  List<AddressPredictions> predictedDestinationAddressList = [];

  @override
  void dispose() {
    pickUpController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    pickUpController.text = Provider.of<AppData>(context).pickUpLocation != null
        ? Provider.of<AppData>(context).pickUpLocation.placeName
        : "unknown location";

    return Scaffold(
      body: Stack(
        children: [
          Container(),
          Positioned.fill(
            child: Material(
              elevation: 10,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: ListView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                    top: size * 0.1, left: 15, right: 20, bottom: size * 0.05),
                children: [
                  buildTitlenSubtitleText(
                      'Where do you want your package delivered?',
                      Colors.black,
                      20,
                      FontWeight.w600,
                      TextAlign.start,
                      null),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.0),
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
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            buildTitlenSubtitleText(
                                'Search destination',
                                Color(0xFFB4B5C3),
                                14,
                                FontWeight.normal,
                                TextAlign.start,
                                null),
                          ],
                        ),
                      ),
                    ),
                  ),
                  predictedDestinationAddressList.length > 0
                      ? SizedBox(
                          height: 25,
                        )
                      : SizedBox(
                          height: 30,
                        ),
                  predictedDestinationAddressList.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: predictedDestinationAddressList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return PredictedAddressTile(
                              addressPredictions:
                                  predictedDestinationAddressList[index],
                              label: 'destination',
                            );
                          },
                        )
                      : Container(),
                  buildCustomListTile(
                      getIcon(Icons.location_on_outlined, 25, Colors.grey[600]),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            buildTitlenSubtitleText('Location', Colors.black,
                                13, FontWeight.bold, TextAlign.start, null),
                            buildTitlenSubtitleText(
                                Provider.of<AppData>(context).pickUpLocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickUpLocation
                                        .placeName
                                    : "unknown location",
                                Colors.grey,
                                12,
                                FontWeight.normal,
                                TextAlign.start,
                                null),
                          ],
                        ),
                      ),
                      null,
                      5.0,
                      false),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      onTap: () {
                        showToast(context, 'Please enter package destination',
                            Colors.red);
                      },
                      child: buildSubmitButton('NEXT', 25.0),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: _searchScreen(size),
          ),
        ],
      ),
    );
  }

  buildSearchField(String hintText, IconData iconData,
      TextEditingController controller, bool readOnly) {
    return Row(
      children: [
        Icon(iconData),
        SizedBox(width: 10.0),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: TextFormField(
                readOnly: readOnly,
                onChanged: (val) {
                  _getDestinationAddress(val);
                },
                controller: controller,
                decoration: InputDecoration(
                    hintText: hintText,
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                    EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _searchScreen(double size) {
    return Material(
      elevation: 10,
      child: Column(
        children: [
          SizedBox(
            height: size * 0.07,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: getIcon(LineAwesomeIcons.times, 25, Colors.black),
                ),
                SizedBox(
                  width: 30,
                ),
                buildTitlenSubtitleText('Enter destination', Colors.black, 18,
                    FontWeight.w600, TextAlign.start, null),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.only(left: 13, right: 15),
            child: buildSearchField(
                'Pickup location', Icons.location_on, pickUpController, true),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 13, right: 15),
            child: buildSearchField(
                'Enter destination', Icons.location_on, destinationController,
                false),
          ),
          SizedBox(
            height: size * 0.011,
          ),
        ],
      ),
    );
  }


  _getDestinationAddress(String addressName) async {
    if (addressName.length == 1)
      showToast(context, 'Fetching predictions', null);


    if (addressName.length > 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$addressName&key=$kMapKey&sessiontoken=1234567890&components=country:ng";

      var response = await RequestAssistant.getRequest(url);

      if (response == 'Failed') {
        return;
      }

      if (response["status"] == "OK") {
        var predictions = response["predictions"];

        var list = (predictions as List)
            .map((json) => AddressPredictions.FromJson(json))
            .toList();

        setState(() {
          predictedDestinationAddressList = list;
        });
      }
    }

  }
}



