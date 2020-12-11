import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Screens/Dashboard/searchScreen.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/drawer.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';
import 'package:fronto/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: buildDrawer(context),
      body: Stack(
        children: [
          GoogleMap(
            padding:
                EdgeInsets.only(bottom: kMapBottomPadding, top: kMapTopPadding),
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            trafficEnabled: true,
            myLocationButtonEnabled: _locationButton,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              _newGoogleMapController = controller;

              setState(() {
                _locationButton = true;
                kMapBottomPadding = size * 0.39;
              });
              _getUserLocation();
            },
          ),
          Positioned(
            top: 0.0,
            left: 8,
            child: InkWell(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white),
                height: 45,
                width: 45,
                margin: EdgeInsets.only(left: 10, right: 10, top: size * 0.07),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    getIcon(Icons.menu, 25, Colors.black),
                  ],
                ),
              ),
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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
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

                  // SizedBox(height: 18,),

                  buildNonEditTextField(
                      'Address',
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
                                TextOverflow.visible),
                          ],
                        ),
                      ),
                      getIcon(Icons.edit, 20, Colors.black54),
                      5.0,
                      true),

                  SizedBox(
                    height: 8,
                  ),

                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: buildSubmitButton('NEXT', 25.0),
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
    Position position = await Geolocator.getCurrentPosition(
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
