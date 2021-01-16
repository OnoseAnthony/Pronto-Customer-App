import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/address.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/notification.dart';
import 'package:fronto/Screens/Dashboard/searchScreen.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/Services/requestAssistant.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/dialogs.dart';
import 'package:fronto/SharedWidgets/drawer.dart';
import 'package:fronto/SharedWidgets/predictedAddressTile.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';
import 'package:fronto/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  bool fromLocationHandler;
  Position positionFromLocationHandler;

  HomeScreen(
      {@required this.fromLocationHandler,
      @required this.positionFromLocationHandler});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController _newGoogleMapController;
  Position _currentUserPosition;
  bool _locationButton = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.072264, 7.491302),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kWhiteColor,
      key: _scaffoldKey,
      drawer: buildDrawer(
        context,
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding:
                EdgeInsets.only(bottom: kMapBottomPadding, top: kMapTopPadding),
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            trafficEnabled: false,
            myLocationButtonEnabled: _locationButton,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              _newGoogleMapController = controller;

              _getUserLocation();

              setState(() {
                _locationButton = true;
                kMapBottomPadding = size * 0.39;
              });
            },
          ),
          Positioned(
            top: 0.0,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: kWhiteColor),
                    height: 45,
                    width: 45,
                    margin:
                        EdgeInsets.only(left: 10, right: 10, top: size * 0.07),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        getIcon(Icons.menu, 25, Colors.black),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: kWhiteColor),
                    height: 45,
                    width: 45,
                    margin:
                        EdgeInsets.only(left: 10, right: 10, top: size * 0.07),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        builddrawerIcon(
                            'notification', 'assets/images/notification.svg'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: EdgeInsets.only(
                  top: size * 0.02, left: 40, right: 40, bottom: size * 0.01),
              height: size * 0.42,
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.25,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTitlenSubtitleText(
                      'Where do you want your package delivered?',
                      Colors.black,
                      20,
                      FontWeight.w600,
                      TextAlign.start,
                      null),


                  buildNonEditTextField(
                      'Deliver to?',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()))),

                  SizedBox(
                    height: 5,
                  ),

                  buildCustomListTile(
                      getIcon(Icons.location_on_outlined, 25, Colors.grey[600]),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            buildTitlenSubtitleText('Location', Colors.black,
                                13, FontWeight.bold, TextAlign.start, null),
                            buildTitlenSubtitleText(
                                Provider
                                    .of<AppData>(context)
                                    .pickUpLocation !=
                                    null
                                    ? Provider
                                    .of<AppData>(context)
                                    .pickUpLocation
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

                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PickUpScreen()));
                        },
                        child: getIcon(Icons.edit, 20, Colors.black54),
                      ),
                      5.0,
                      true),

                  SizedBox(
                    height: 8,
                  ),

                  Flexible(
                    child: InkWell(
                      onTap: () {
                        showToast(context, 'Please select package destination',
                            kErrorColor, true);
                      },
                      child: buildSubmitButton('NEXT', 25.0, false),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getUserLocation() async {
    Position position = widget.fromLocationHandler
        ? widget.positionFromLocationHandler
        : await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
    _currentUserPosition = position;

    LatLng _userLatitudeLongitudePosition =
        LatLng(_currentUserPosition.latitude, _currentUserPosition.longitude);

    CameraPosition _cameraPosition =
        CameraPosition(target: _userLatitudeLongitudePosition, zoom: 15);
    _newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

    await AssistantMethods.searchCoordinateAddress(
        _currentUserPosition, context);
  }
}


class PickUpScreen extends StatefulWidget {
  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {

  TextEditingController pickUpController = TextEditingController();
  List<AddressPredictions> predictedDestinationAddressList = [];

  @override
  void dispose() {
    pickUpController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double size = MediaQuery
        .of(context)
        .size
        .height;

    pickUpController.text = Provider
        .of<AppData>(context)
        .pickUpLocation != null
        ? Provider
        .of<AppData>(context)
        .pickUpLocation
        .placeName
        : "unknown location";

    return Scaffold(
      body: Stack(
        children: [

          Container(),

          Positioned.fill(
            child: Material(
              elevation: 10,
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: ListView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                    top: size * 0.1, left: 15, right: 20, bottom: size * 0.05),
                children: [
                  predictedDestinationAddressList.length > 0
                      ? SizedBox(
                          height: 80,
                        )
                      : SizedBox(
                    height: 55,
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
                        label: 'pickUp',
                      );
                    },
                  )
                      : Container(),

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

  _searchScreen(double size) {
    return Material(
      elevation: 5,
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
                buildTitlenSubtitleText(
                    'Enter new pick up location', Colors.black, 18,
                    FontWeight.w600, TextAlign.start, null),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.only(left: 13, right: 15),
            child: buildSearchField(),
          ),
          SizedBox(
            height: size * 0.011,
          ),
        ],
      ),
    );
  }

  buildSearchField() {
    return Row(
      children: [
        Icon(Icons.location_on),
        SizedBox(width: 10.0),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: TextFormField(
                onChanged: (val) async {
                  _getNewLocationAddress(val);
                },
                decoration: InputDecoration(
                    hintText: pickUpController.text,
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

  _getNewLocationAddress(String addressName) async {
    if (addressName.length == 1)
      showToast(context, 'Fetching predictions', null, false);

    if (addressName.length > 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$addressName&key=$kMapKey&sessiontoken=1234567890&components=country:ng";

      var response = await RequestAssistant.getRequest(url);

      if (response == 'Failed') {
        print('Lookup autocomplete failed');
        return;
      }

      if (response["status"] == "OK") {
        print('Autocomplete passed');

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

