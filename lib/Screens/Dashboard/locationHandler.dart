import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/notification.dart';
import 'package:fronto/Screens/Dashboard/LocationFromMap.dart';
import 'package:fronto/Screens/Dashboard/homeScreen.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/Services/firebase/firestore.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/drawer.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHandler extends StatefulWidget {
  @override
  _LocationHandlerState createState() => _LocationHandlerState();
}

class _LocationHandlerState extends State<LocationHandler> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.072264, 7.491302),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    getCustomUser();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  top: size * 0.01, left: 40, right: 40, bottom: size * 0.01),
              height: size * 0.52,
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
                  CircleAvatar(
                    backgroundColor: kWhiteColor,
                    radius: 60.0,
                    child: SvgPicture.asset(
                      'assets/images/locationHandler.svg',
                      semanticsLabel: 'Location Handler Logo',
                    ),
                  ),
                  buildTitlenSubtitleText('Where are you?', Colors.black, 20,
                      FontWeight.bold, TextAlign.center, null),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: buildTitlenSubtitleText(
                        'Set your location so we can pick up your package at the right spot and find vehicles available around you',
                        Colors.black,
                        11,
                        FontWeight.normal,
                        TextAlign.center,
                        null),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    fromLocationHandler: false,
                                    positionFromLocationHandler: null,
                                  )));
                    },
                    child: buildSubmitButton('SET AUTOMATICALLY', 25.0, true),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        enableDrag: false,
                        isDismissible: false,
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height,
                          child: LocationFromMap(),
                        ),
                      );
                    },
                    child:
                        buildSubmitButton('SET PICKUP MANUALLY', 25.0, false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getCustomUser() async {
    await DatabaseService(
            firebaseUser: AuthService().getCurrentUser(), context: context)
        .getCustomUserData();
    setState(() {});
  }
}
