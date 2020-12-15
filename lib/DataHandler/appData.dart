import 'package:flutter/cupertino.dart';
import 'package:fronto/Models/address.dart';
import 'package:fronto/Models/directions.dart';
import 'package:fronto/Models/orders.dart';
import 'package:fronto/Models/users.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, destinationLocation;

  Directions directionInfo;

  User userInfo;

  OrderData orderDatum;

  Order orderDetails;

  int chargeAmount;

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

  updateUserInfo(User user) {
    userInfo = user;
    notifyListeners();
  }

  updateOrderImages(OrderData orderData) {
    orderDatum = orderData;
    notifyListeners();
  }

  updateOrderDetails(Order order) {
    orderDetails = order;
    notifyListeners();
  }

  updateChargeAmount(int amount) {
    chargeAmount = amount;
  }
}
