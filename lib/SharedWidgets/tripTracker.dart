import 'package:flutter/material.dart';
import 'package:fronto/SharedWidgets/buttons.dart';

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
          color: Colors.blue,
        ),
      ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.06,
        color: Colors.blue,
      ),
      index == 0
          ? Container(
              height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: getIcon(Icons.message, 10, Colors.white),
            )
          : Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.07,
        color: index == 1 || index == 2 ? Colors.blue : Colors.grey[300],
      ),
      index == 1
          ? Container(
              height: 25,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: getIcon(Icons.message, 10, Colors.white),
            )
          : Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 2 ? Colors.blue : Colors.grey[300],
              ),
            ),
      Container(
        height: 2,
        width: MediaQuery.of(context).size.height * 0.08,
        color: index == 2 ? Colors.blue : Colors.grey[300],
      ),
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == 2 ? Colors.blue : Colors.grey[300],
        ),
      ),
    ],
  );
}
