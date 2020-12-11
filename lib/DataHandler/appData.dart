import 'package:flutter/cupertino.dart';
import 'package:fronto/Models/address.dart';
import 'package:fronto/Models/directions.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, destinationLocation;

  Directions directionInfo;

  updatePickupLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  updateDestinationpLocationAddress(Address destinationAddress) {
    destinationLocation = destinationAddress;
    notifyListeners();
  }

  updateDirectionsInfo(Directions directions) {
    directionInfo = directions;
    notifyListeners();
  }
}
