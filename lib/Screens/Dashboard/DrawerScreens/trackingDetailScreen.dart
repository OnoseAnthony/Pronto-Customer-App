import 'package:flutter/material.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/tripTracker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TrackPackageDetailScreen extends StatelessWidget {
  String orderId;
  String pickUpDate;
  String dropOffDate;
  String pickUpState;
  String destinationState;
  int index;

  TrackPackageDetailScreen(
      {@required this.orderId,
      @required this.pickUpDate,
      @required this.dropOffDate,
      @required this.pickUpState,
      @required this.destinationState,
      @required this.index});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(left: 40, right: 40),
            child: ListView.builder(
              padding: EdgeInsets.only(top: size * 0.15),
              scrollDirection: Axis.vertical,
              itemCount: index,
              itemBuilder: (context, index) {
                return buildPackageTrackerCard(size, context, index);
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
                  buildTitlenSubtitleText('Package Details', Colors.black, 18,
                      FontWeight.w600, TextAlign.start, null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPackageTrackerCard(double size, context, int index) {
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
              left: 30, right: 30, bottom: size * 0.02, top: size * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitlenSubtitleText(orderId, Colors.black38, 14,
                  FontWeight.w700, TextAlign.start, null),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTitlenSubtitleText(pickUpDate, Colors.black26, 13,
                      FontWeight.w700, TextAlign.start, null),
                  buildTitlenSubtitleText(dropOffDate, Colors.black26, 13,
                      FontWeight.w700, TextAlign.start, null),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTitlenSubtitleText(pickUpState, Colors.black54, 16,
                      FontWeight.w700, TextAlign.start, null),
                  buildTitlenSubtitleText(destinationState, Colors.black54, 16,
                      FontWeight.w700, TextAlign.start, null),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              buildDestinationTracker(context, index),
              SizedBox(
                height: 20,
              ),
              Center(
                child: buildTitlenSubtitleText(
                    'Heading to the city of $destinationState',
                    Colors.black26,
                    13,
                    FontWeight.w700,
                    TextAlign.center,
                    null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
