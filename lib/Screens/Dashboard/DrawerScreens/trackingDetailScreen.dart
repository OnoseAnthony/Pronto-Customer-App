import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fronto/Models/directions.dart';
import 'package:fronto/Services/mapServices.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TrackProductOnMap extends StatefulWidget {
  Map pickUpLocation;
  Map destinationLocation;

  TrackProductOnMap(
      {@required this.pickUpLocation, @required this.destinationLocation});

  @override
  _TrackProductOnMapState createState() => _TrackProductOnMapState();
}

class _TrackProductOnMapState extends State<TrackProductOnMap> {
  Directions tripInfo;
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController _newGoogleMapController;
  List<LatLng> polyLineCoordinates = [];
  Position _currentUserPosition;
  Set<Polyline> polyLineSet = {};
  LatLngBounds directionBounds;
  Set<Marker> mapMarkers = {};
  Set<Circle> mapMarkerCircles = {};
  BitmapDescriptor markerIcon;

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(9.072264, 7.491302), zoom: 15);

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(60, 60)), 'assets/images/truck1.png')
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
          myLocationEnabled: false,
          markers: mapMarkers,
          circles: mapMarkerCircles,
          polylines: polyLineSet,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController.complete(controller);
            _newGoogleMapController = controller;
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
                  borderRadius: BorderRadius.circular(100), color: kWhiteColor),
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
      ],
    );
  }

  _displayDirectionsOnMap() async {
    var pickUp = widget.pickUpLocation;
    var destination = widget.destinationLocation;

    var pickUpLatLng = LatLng(
        double.parse(pickUp['latitude']), double.parse(pickUp['longitude']));
    var destinationLatLng = LatLng(double.parse(destination['latitude']),
        double.parse(destination['longitude']));

    Directions directionInfo =
        await AssistantMethods.getDirections(pickUpLatLng, destinationLatLng);

    setState(() {
      tripInfo = directionInfo;
    });

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
          title: '${pickUp['placeName']} ${tripInfo.durationText}',
          snippet: "my Location ${tripInfo.distanceText}"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker destinationMarker = Marker(
      icon: markerIcon,
      infoWindow: InfoWindow(
          title: '${destination['placeName']} ${tripInfo.durationText}',
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

    _displayDirectionsOnMap();
  }
}
