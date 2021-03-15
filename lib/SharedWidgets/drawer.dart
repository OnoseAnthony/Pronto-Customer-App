import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/about.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/editProfile.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/notification.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/promotion.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/support.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/trackingListScreen.dart';
import 'package:fronto/Screens/Dashboard/paymentScreen.dart';
import 'package:fronto/Screens/onboarding/getStarted.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/dialogs.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/constants.dart';
import 'package:provider/provider.dart';

buildDrawer(
  BuildContext context,
) {
  double size = MediaQuery.of(context).size.width * 0.08;
  return Container(
    width: MediaQuery.of(context).size.width * 0.80,
    child: Drawer(
      child: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 150,
                  padding: EdgeInsets.symmetric(horizontal: size * 0.35),
                  child: DrawerHeader(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(isFromAuth: false,)));
                      },
                      child: buildCustomListTile(
                          Provider.of<AppData>(context, listen: false)
                                          .userInfo !=
                                      null &&
                                  Provider.of<AppData>(context, listen: false)
                                          .userInfo
                                          .photoUrl !=
                                      ''
                              ? Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: Provider.of<AppData>(context,
                                            listen: false)
                                        .userInfo
                                        .photoUrl,
                                    placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kPrimaryColor),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : buildContainerIcon(Icons.person, kPrimaryColor),
                          buildTitlenSubtitleText(
                              Provider.of<AppData>(context, listen: false)
                                          .userInfo !=
                                      null
                                  ? '${Provider.of<AppData>(context).userInfo.fName} ${Provider.of<AppData>(context).userInfo.lName}'
                                  : 'Welcome, User',
                              Colors.black,
                              18,
                              FontWeight.bold,
                              TextAlign.center,
                              null),
                          null,
                          15.0,
                          false),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                        chargeAmount: 1,
                                        type: 'drawer',
                                      )));
                        },
                        child: buildCustomListTile(
                            builddrawerIcon(
                                'credit card', 'assets/images/creditCard.svg'),
                            buildTitlenSubtitleText('Payments', kPrimaryColor,
                                16, FontWeight.normal, TextAlign.start, null),
                            null,
                            12.0,
                            false),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackingListScreen()));
                        },
                        child: buildCustomListTile(
                            builddrawerIcon(
                                'location', 'assets/images/location.svg'),
                            buildTitlenSubtitleText(
                                'Track package',
                                Colors.black,
                                16,
                                FontWeight.normal,
                                TextAlign.start,
                                null),
                            null,
                            12.0,
                            false),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationScreen()));
                        },
                        child: buildCustomListTile(
                            builddrawerIcon('notification',
                                'assets/images/notification.svg'),
                            buildTitlenSubtitleText(
                                'Notification',
                                Colors.black,
                                16,
                                FontWeight.normal,
                                TextAlign.start,
                                null),
                            null,
                            12.0,
                            false),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromotionScreen()));
                        },
                        child: buildCustomListTile(
                            builddrawerIcon(
                                'promotion', 'assets/images/promotion.svg'),
                            buildTitlenSubtitleText('Promotion', Colors.black,
                                16, FontWeight.normal, TextAlign.start, null),
                            null,
                            12.0,
                            false),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SupportScreen()));
                        },
                        child: buildCustomListTile(
                            builddrawerIcon(
                                'support', 'assets/images/support.svg'),
                            buildTitlenSubtitleText('Support', Colors.black, 16,
                                FontWeight.normal, TextAlign.start, null),
                            null,
                            12.0,
                            false),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutScreen()));
                        },
                        child: buildCustomListTile(
                            builddrawerIcon('about', 'assets/images/about.svg'),
                            buildTitlenSubtitleText('About', Colors.black, 16,
                                FontWeight.normal, TextAlign.start, null),
                            null,
                            12.0,
                            false),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => NavigationLoader(context),
                          );
                          bool isLoggedOut = await AuthService().signOut();
                          if (isLoggedOut)
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GetStarted()),
                                (route) => false);
                          else {
                            Navigator.pop(context);
                          }
                        },
                        child: buildCustomListTile(
                            getIcon(Icons.login_outlined, 22, Colors.black),
                            buildTitlenSubtitleText('Signout', Colors.black, 16,
                                FontWeight.normal, TextAlign.start, null),
                            null,
                            12.0,
                            false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 3,
              right: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitlenSubtitleText(
                              'Earn 150k',
                              Color(0xFF27AE60),
                              20,
                              FontWeight.bold,
                              TextAlign.start,
                              null),
                          SizedBox(
                            height: 3,
                          ),
                          buildTitlenSubtitleText(
                              'Monthly Now.',
                              Color(0xFF27AE60),
                              21,
                              FontWeight.bold,
                              TextAlign.start,
                              null),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => null,
                      child: buildSubmitButton('RIDE NOW', 25.0, false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget builddrawerIcon(String label, String imagePath) {
  return Container(
    height: 25,
    width: label != 'location' || label != 'notification' ? 24 : 22,
    child: Padding(
      padding: label != 'location' || label != 'notification'
          ? EdgeInsets.all(2.0)
          : EdgeInsets.all(0.0),
      child: SvgPicture.asset(
        imagePath,
        semanticsLabel: 'label icon',
      ),
    ),
  );
}
