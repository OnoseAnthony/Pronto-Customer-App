import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Screens/Dashboard/homeScreen.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';
import 'package:fronto/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationFromMap extends StatefulWidget {
  @override
  _LocationFromMapState createState() => _LocationFromMapState();
}

class _LocationFromMapState extends State<LocationFromMap> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController _newGoogleMapController;
  Position _currentUserPosition;
  Position locationHandlerPosition;
  BitmapDescriptor markerIcon;
  Set<Marker> mapMarkers = {};
  Set<Circle> mapMarkerCircles = {};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.072264, 7.491302),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(160, 160)),
            'assets/images/markerIcon.png')
        .then((onValue) {
      markerIcon = onValue;
    });
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        GoogleMap(
          padding:
              EdgeInsets.only(bottom: kMapBottomPadding, top: kMapTopPadding),
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          markers: mapMarkers,
          circles: mapMarkerCircles,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController.complete(controller);
            _newGoogleMapController = controller;
          },
          onTap: ((newLatLng) => updatePosition(newLatLng)),
        ),
        Positioned(
          top: 0.0,
          left: 8,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: kWhiteColor),
              height: 45,
              width: 45,
              margin: EdgeInsets.only(left: 10, right: 10, top: size * 0.07),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  getIcon(Icons.arrow_back, 25, kPrimaryColor),
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
            height: size * 0.30,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitlenSubtitleText('Set pickup location', Colors.black,
                        20, FontWeight.bold, TextAlign.start, null),
                    SizedBox(
                      height: 5,
                    ),
                    buildTitlenSubtitleText(
                        'Tap on preferred area on map to select pickup location',
                        Colors.black,
                        11,
                        FontWeight.normal,
                        TextAlign.start,
                        null),
                  ],
                ),
                buildNonEditTextField(
                  Provider.of<AppData>(context).pickUpLocation != null
                      ? Provider.of<AppData>(context).pickUpLocation.placeName
                      : "unknown location",
                  null,
                ),
                SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    fromLocationHandler: true,
                                    positionFromLocationHandler:
                                        locationHandlerPosition,
                                  )));
                    },
                    child: buildSubmitButton('CONFIRM', 25.0, false),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

    _displayMarkerOnMap();
  }

  _displayMarkerOnMap() async {
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;

    var pickUpLatLng =
        LatLng(double.parse(pickUp.latitude), double.parse(pickUp.longitude));

    Marker pickUpMarker = Marker(
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: '${pickUp.placeName}',
          snippet: "${pickUp.latitude} ${pickUp.longitude}"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
      draggable: true,
    );

    Circle pickUpMarkerCircle = Circle(
      fillColor: kWhiteColor,
      center: pickUpLatLng,
      radius: 10,
      strokeWidth: 3,
      strokeColor: kWhiteColor,
      circleId: CircleId("pickUpId"),
    );

    setState(() {
      mapMarkers.add(pickUpMarker);
      mapMarkerCircles.add(pickUpMarkerCircle);
    });
  }

  updatePosition(LatLng _position) async {
    Position updatedPosition = Position(
        latitude: _position.latitude,
        longitude: _position.longitude,
        accuracy: 100.0);

    await AssistantMethods.searchCoordinateAddress(updatedPosition, context);

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;

    Marker marker = mapMarkers.firstWhere(
        (p) => p.markerId == MarkerId('pickUpId'),
        orElse: () => null);

    mapMarkers.remove(marker);
    mapMarkers.add(
      Marker(
        markerId: MarkerId('pickUpId'),
        position: LatLng(_position.latitude, _position.longitude),
        draggable: true,
        icon: markerIcon,
        infoWindow: InfoWindow(
            title: '${pickUp.placeName}',
            snippet: "${pickUp.latitude} ${pickUp.longitude}"),
      ),
    );
    locationHandlerPosition = updatedPosition;
    setState(() {});
  }
}
