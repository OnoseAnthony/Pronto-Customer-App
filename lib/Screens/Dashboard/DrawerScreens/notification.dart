import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto/Models/orders.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/Services/firebase/firestore.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(
              left: 40,
              right: 40,
            ),
            child: StreamBuilder<List<OrderNotification>>(
              stream: DatabaseService(
                      firebaseUser: AuthService().getCurrentUser(),
                      context: context)
                  .notificationStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError)
                  return buildStreamBuilderNullContainer();
                else if (snapshot.connectionState == ConnectionState.active) {
                  List<OrderNotification> orderNotificationList = snapshot.data;
                  if (snapshot.data != null &&
                      orderNotificationList.length >= 1) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: size * 0.15),
                      scrollDirection: Axis.vertical,
                      itemCount: orderNotificationList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: buildCard(
                            orderNotificationList[index].title,
                            orderNotificationList[index].body,
                            orderNotificationList[index]
                                .driverInfo['driverName'],
                            orderNotificationList[index]
                                .driverInfo['driverPhone'],
                            size,
                          ),
                        );
                      },
                    );
                  } else {
                    return buildNullFutureBuilderStream(
                        context, 'notification');
                  }
                } else {
                  return buildStreamBuilderLoader();
                }
              },
            ),
          ),
          getDrawerNavigator(context, size, 'Notification'),
        ],
      ),
    );
  }

  buildCard(
      String title, String body, String driverName, String driverPhone, size) {
    return Card(
      shadowColor: kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, bottom: size * 0.02, top: size * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                buildTitlenSubtitleText(title, Colors.black38, 14,
                    FontWeight.bold, TextAlign.start, null),
                SizedBox(
                  width: 5,
                ),
                Container(
                  height: 20,
                  width: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      title == 'Delivered'
                          ? 'assets/images/Vector.svg'
                          : 'assets/images/thumb_up.svg',
                      semanticsLabel: 'vector icon',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            buildTitlenSubtitleText(body, Colors.black26, 13, FontWeight.w700,
                TextAlign.start, null),
            title == 'Pending'
                ? SizedBox(
                    height: 30,
                  )
                : SizedBox(
                    height: 0,
                  ),
            title == 'Pending'
                ? InkWell(
                    onTap: () {
                      launch("tel://$driverPhone");
                    },
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xFF27AE60),
                      ),
                      child: Row(
                        children: [
                          getIcon(Icons.phone, 20.0, kWhiteColor),
                          SizedBox(
                            width: 25,
                          ),
                          Text(
                            'CALL MR. ${driverName.toUpperCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
