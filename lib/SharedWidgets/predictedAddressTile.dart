import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/address.dart';
import 'package:fronto/Screens/Dashboard/directions.dart';
import 'package:fronto/Services/requestAssistant.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/divider.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/constants.dart';
import 'package:provider/provider.dart';

class PredictedAddressTile extends StatelessWidget {
  final AddressPredictions addressPredictions;

  PredictedAddressTile({Key key, this.addressPredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getDestinationAddressDetails(addressPredictions.place_id, context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            buildCustomListTile(
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                child: getIcon(Icons.add_location, 25, kPrimaryColor),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitlenSubtitleText(
                        addressPredictions.main_text,
                        Colors.black,
                        16.0,
                        FontWeight.bold,
                        TextAlign.start,
                        TextOverflow.visible),
                    SizedBox(
                      height: 5,
                    ),
                    buildTitlenSubtitleText(
                        addressPredictions.secondary_text,
                        Colors.black,
                        12,
                        FontWeight.normal,
                        TextAlign.start,
                        TextOverflow.visible)
                  ],
                ),
              ),
              null,
              15.0,
              false,
            ),
            SizedBox(
              height: 20,
            ),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  getDestinationAddressDetails(String addressId, context) async {
    print('Fetching your destinaiton details');
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$addressId&key=$kMapKey";

    var response = await RequestAssistant.getRequest(url);

    print('Fetching and setting your destination details');

    if (response == 'Failed') return;

    if (response["status"] == "OK") {
      Address address = Address(
        placeName: response["result"]["name"],
        placeId: addressId,
        latitude: response["result"]["geometry"]["location"]["lat"].toString(),
        longitude: response["result"]["geometry"]["location"]["lng"].toString(),
      );

      Provider.of<AppData>(context, listen: false)
          .updateDestinationpLocationAddress(address);

      print('Destination address is ${address.placeName}');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DirectionScreen()));
    }
  }
}
