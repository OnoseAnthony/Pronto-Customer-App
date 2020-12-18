import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fronto/Models/address.dart';
import 'package:fronto/Models/directions.dart';
import 'package:fronto/Models/orders.dart';
import 'package:fronto/Models/users.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, destinationLocation;

  Directions directionInfo;

  User firebaseUser;

  CustomUser userInfo;

  orderRequest orderRequestInfo;

  Order orderDetails;

  int chargeAmount;

  String paymentReference;

  String paymentStatus;

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

  updateFirebaseUser(User user) {
    firebaseUser = user;
    notifyListeners();
  }

  updateUserInfo(CustomUser user) {
    userInfo = user;
    notifyListeners();
  }

  updateOrderRequest(orderRequest orderRequest) {
    orderRequestInfo = orderRequest;
    notifyListeners();
  }

  updateOrderDetails(Order order) {
    orderDetails = order;
    notifyListeners();
  }

  updateChargeAmount(int amount) {
    chargeAmount = amount;
    notifyListeners();
  }

  updatePaymentReference(String reference) {
    paymentReference = reference;
    notifyListeners();
  }

  updatePaymentStatus(String status) {
    paymentStatus = status;
    notifyListeners();
  }
}
