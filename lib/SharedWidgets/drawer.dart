import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/text.dart';

buildDrawer(
  BuildContext context,
) {
  double size = MediaQuery.of(context).size.width * 0.08;
  Widget _column = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildTitlenSubtitleText(
          'Anthony', Colors.black, 18, FontWeight.bold, TextAlign.center, null),
      SizedBox(
        height: 3,
      ),
      buildTitlenSubtitleText('View profile', Colors.grey, 13,
          FontWeight.normal, TextAlign.center, null),
    ],
  );
  return Container(
    width: MediaQuery.of(context).size.width * 0.80,
    child: Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: size * 0.35),
              child: DrawerHeader(
                child: buildCustomListTile(buildContainerIcon(Icons.person),
                    _column, null, 15.0, false),
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
                  buildCustomListTile(
                      getIcon(Icons.credit_card, 22, Colors.black),
                      buildTitlenSubtitleText('Payments', Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      null,
                      12.0,
                      false),
                  SizedBox(
                    height: 25.0,
                  ),
                  buildCustomListTile(
                      getIcon(Icons.location_on, 22, Colors.black),
                      buildTitlenSubtitleText('Track package', Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      null,
                      12.0,
                      false),
                  SizedBox(
                    height: 25.0,
                  ),
                  buildCustomListTile(
                      getIcon(Icons.live_help_rounded, 22, Colors.black),
                      buildTitlenSubtitleText('Support', Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      null,
                      12.0,
                      false),
                  SizedBox(
                    height: 25.0,
                  ),
                  buildCustomListTile(
                      getIcon(Icons.info, 22, Colors.black),
                      buildTitlenSubtitleText('About', Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      null,
                      12.0,
                      false),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
