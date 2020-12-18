import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fronto/Models/orders.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/trackingDetailScreen.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/Services/firebase/firestore.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TrackingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    User user = AuthService().getCurrentUser();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(left: 40, right: 40),
            child: FutureBuilder(
              future: DatabaseService(firebaseUser: user, context: context)
                  .getUserOrderList(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    List<Order> orderList = snapshot.data;
                    return ListView.builder(
                      padding: EdgeInsets.only(top: size * 0.15),
                      scrollDirection: Axis.vertical,
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Card(
                            borderOnForeground: false,
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 8,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  bottom: size * 0.02,
                                  top: size * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTitlenSubtitleText(
                                      orderList[index].orderID,
                                      Colors.black38,
                                      14,
                                      FontWeight.w700,
                                      TextAlign.start,
                                      null),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildTitlenSubtitleText(
                                          orderList[index].date,
                                          Colors.black26,
                                          13,
                                          FontWeight.w700,
                                          TextAlign.start,
                                          null),
                                      buildTitlenSubtitleText(
                                          orderList[index].orderStatus ==
                                                  'OrderStatus.SUBMITTED'
                                              ? 'Pending'
                                              : getCreationDate(),
                                          Colors.black26,
                                          13,
                                          FontWeight.w700,
                                          TextAlign.start,
                                          null),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TrackPackageDetailScreen(
                                                    orderId: orderList[index]
                                                        .orderID,
                                                    pickUpDate:
                                                        orderList[index].date,
                                                    dropOffDate: orderList[
                                                                    index]
                                                                .orderStatus ==
                                                            'OrderStatus.SUBMITTED'
                                                        ? 'Pending'
                                                        : getCreationDate(),
                                                    pickUpState:
                                                        orderList[index]
                                                                .pickUpAddress[
                                                            'stateName'],
                                                    destinationState: orderList[
                                                                index]
                                                            .destinationAddress[
                                                        'stateName'],
                                                    index: orderList[index]
                                                        .trackState,
                                                  )));
                                    },
                                    child: buildSubmitButton(
                                        'TRACKING INFORMATION', 5.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                        child: Center(
                            child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 40, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            buildTitlenSubtitleText(
                                'No Package yet...',
                                Colors.white,
                                14,
                                FontWeight.bold,
                                TextAlign.center,
                                null),
                          ],
                        ),
                      ),
                    )));
                  }
                } else {
                  return Container(
                    child: Center(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 40, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SpinKitWanderingCubes(
                                color: Colors.white,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              buildTitlenSubtitleText(
                                  'please wait a moment...',
                                  Colors.white,
                                  14,
                                  FontWeight.bold,
                                  TextAlign.center,
                                  null),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            top: size * 0.07,
            left: 15.0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  getIcon(LineAwesomeIcons.times, 20, Colors.black),
                  SizedBox(
                    width: 25,
                  ),
                  buildTitlenSubtitleText('Track package', Colors.black, 18,
                      FontWeight.w600, TextAlign.start, null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
