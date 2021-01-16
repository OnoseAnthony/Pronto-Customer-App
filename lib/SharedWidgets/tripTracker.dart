import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fronto/constants.dart';

buildDestinationTracker(context, int index) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimaryColor,
        ),
      ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.06,
        color: kPrimaryColor,
      ),
      index == 1
          ? Container(
        height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  'assets/images/truck.svg',
                  semanticsLabel: 'truck icon',
                ),
              ),
            )
          : Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
            ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.07,
        color: index == 2 || index == 3 ? kPrimaryColor : Colors.grey[300],
      ),
      index == 2
          ? Container(
        height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  'assets/images/truck.svg',
                  semanticsLabel: 'truck icon',
                ),
              ),
            )
          : Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 3 ? kPrimaryColor : Colors.grey[300],
              ),
            ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.08,
        color: index == 3 ? kPrimaryColor : Colors.grey[300],
      ),
      index == 3
          ? Container(
              height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  'assets/images/Vector.svg',
                ),
              ),
            )
          : Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),
    ],
  );
}
