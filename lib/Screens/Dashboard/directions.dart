import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/directions.dart';
import 'package:fronto/Screens/Dashboard/orderRequestDescription.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DirectionScreen extends StatefulWidget {
  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  Directions tripInfo;
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController _newGoogleMapController;
  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  LatLngBounds directionBounds;
  Set<Marker> mapMarkers = {};
  Set<Circle> mapMarkerCircles = {};
  bool _locationButton = false;
  BitmapDescriptor markerIcon;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.072264, 7.491302),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _displayDirectionsOnMap();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/images/truck1.png')
        .then((onValue) {
      markerIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding:
                EdgeInsets.only(bottom: kMapBottomPadding, top: kMapTopPadding),
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: _locationButton,
            polylines: polyLineSet,
            markers: mapMarkers,
            circles: mapMarkerCircles,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              _newGoogleMapController = controller;

              setState(() {
                _locationButton = true;
                kMapBottomPadding = size * 0.19;
              });
            },
          ),
          Positioned(
            top: 0.0,
            left: 10,
            child: InkWell(
              onTap: () {
                setState(() {
                  polyLineSet.clear();
                  mapMarkers.clear();
                  mapMarkerCircles.clear();
                  polyLineCoordinates.clear();
                });
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: kWhiteColor),
                height: 45,
                width: 45,
                margin: EdgeInsets.only(left: 10, right: 10, top: size * 0.07),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    getIcon(LineAwesomeIcons.times, 25, Colors.black),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
                maxChildSize: 0.83,
                minChildSize: 0.4,
                initialChildSize: 0.83,
                builder: (context, controller) {
                  return OrderScreen(
                    controller: controller,
                    size: size,
                  );
                }),
          ),
        ],
      ),
    );
  }


  _displayDirectionsOnMap() async {
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationLocation;

    var pickUpLatLng =
        LatLng(double.parse(pickUp.latitude), double.parse(pickUp.longitude));
    var destinationLatLng = LatLng(double.parse(destination.latitude),
        double.parse(destination.longitude));


    Directions directionInfo =
        await AssistantMethods.getDirections(pickUpLatLng, destinationLatLng);

    setState(() {
      tripInfo = directionInfo;
    });


    Provider.of<AppData>(context, listen: false)
        .updateDirectionsInfo(directionInfo);

    //convert encoded points to polyLine

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePoints =
        polylinePoints.decodePolyline(directionInfo.encodedPoints);

    polyLineCoordinates.clear();
    if (decodedPolyLinePoints.isNotEmpty) {
      decodedPolyLinePoints.forEach((PointLatLng pointLatLng) {
        polyLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyLine = Polyline(
        color: kPrimaryColor,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLineCoordinates,
        width: 3,
        startCap: Cap.squareCap,
        endCap: Cap.buttCap,
        geodesic: true,
      );

      polyLineSet.add(polyLine);
    });

    if (pickUpLatLng.latitude > destinationLatLng.latitude &&
        pickUpLatLng.longitude > destinationLatLng.longitude)
      directionBounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickUpLatLng);
    else if (pickUpLatLng.longitude > destinationLatLng.longitude)
      directionBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickUpLatLng.longitude));
    else if (pickUpLatLng.latitude > destinationLatLng.latitude)
      directionBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude),
          northeast:
              LatLng(pickUpLatLng.latitude, destinationLatLng.longitude));
    else
      directionBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: destinationLatLng);

    _newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(directionBounds, 70));

    Marker pickUpMarker = Marker(
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: '${pickUp.placeName} ${tripInfo.durationText}',
          snippet: "my Location ${tripInfo.distanceText}"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker destinationMarker = Marker(
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: '${destination.placeName} ${tripInfo.durationText}',
          snippet: "Destination Location ${tripInfo.distanceText}"),
      position: destinationLatLng,
      markerId: MarkerId("destinationId"),
    );

    Circle pickUpMarkerCircle = Circle(
      fillColor: kWhiteColor,
      center: pickUpLatLng,
      radius: 10,
      strokeWidth: 3,
      strokeColor: kWhiteColor,
      circleId: CircleId("pickUpId"),
    );

    Circle destinationMarkerCircle = Circle(
      fillColor: kWhiteColor,
      center: destinationLatLng,
      radius: 10,
      strokeWidth: 3,
      strokeColor: kWhiteColor,
      circleId: CircleId("destinationId"),
    );

    setState(() {
      mapMarkers.add(pickUpMarker);
      mapMarkers.add(destinationMarker);
      mapMarkerCircles.add(pickUpMarkerCircle);
      mapMarkerCircles.add(destinationMarkerCircle);
    });
  }
}
