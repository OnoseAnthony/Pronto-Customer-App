import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fronto/Models/orders.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/trackingDetailScreen.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/Services/firebase/firestore.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/tripTracker.dart';
import 'package:fronto/constants.dart';

class TrackingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    User user = AuthService().getCurrentUser();
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
                  List<Order> orderList = snapshot.data;
                  if (snapshot.data != null && orderList.length >= 1) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: size * 0.15),
                      scrollDirection: Axis.vertical,
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Card(
                            shadowColor: kWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 3,
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
                                                  'OrderStatus.DELIVERED'
                                              ? orderList[index].deliveryDate
                                              : orderList[index].orderStatus ==
                                                      'OrderStatus.PENDING'
                                                  ? 'Processing'
                                                  : 'Pending',
                                          Colors.black26,
                                          13,
                                          FontWeight.w700,
                                          TextAlign.start,
                                          null),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildTitlenSubtitleText(
                                          orderList[index]
                                              .pickUpAddress['stateName'],
                                          Colors.black54,
                                          16,
                                          FontWeight.w700,
                                          TextAlign.start,
                                          null),
                                      buildTitlenSubtitleText(
                                          orderList[index]
                                              .destinationAddress['stateName'],
                                          Colors.black54,
                                          16,
                                          FontWeight.w700,
                                          TextAlign.start,
                                          null),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildDestinationTracker(
                                      context, orderList[index].trackState),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: buildTitlenSubtitleText(
                                        orderList[index].trackState == 3
                                            ? 'Package delivered to ${orderList[index].destinationAddress['stateName']}'
                                            : 'Heading to the city of ${orderList[index].destinationAddress['stateName']}',
                                        Colors.black26,
                                        13,
                                        FontWeight.w700,
                                        TextAlign.center,
                                        null),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () => showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: false,
                                      isDismissible: false,
                                      builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: TrackProductOnMap(
                                          pickUpLocation:
                                              orderList[index].pickUpAddress,
                                          destinationLocation: orderList[index]
                                              .destinationAddress,
                                        ),
                                      ),
                                    ),
                                    child: buildSubmitButton('VIEW', 5.0, true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return buildNullFutureBuilderStream(context, 'package');
                  }
                } else {
                  return buildStreamBuilderLoader();
                }
              },
            ),
          ),
          getDrawerNavigator(context, size, 'Track package'),
        ],
      ),
    );
  }
}
