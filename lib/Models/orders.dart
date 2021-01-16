import 'dart:io';
import 'dart:math';

class Order {
  String userID;
  String userPhone;
  String orderID;
  String paymentReferenceID;
  String date;
  String timeStamp;
  String receiverInfo;
  String receiverPhone;
  String itemDescription;
  String receiverImageUrl;
  String itemUrl;
  String paymentStatus;
  String chargeAmount;
  String orderStatus;
  int trackState;
  Map pickUpAddress;
  Map destinationAddress;
  String driverID;
  String driverPhone;
  String deliveryTimeStamp;
  String deliveryDate;

  Order(
      {this.userID,
      this.userPhone,
      this.orderID,
      this.paymentReferenceID,
      this.date,
      this.timeStamp,
      this.receiverInfo,
      this.receiverPhone,
      this.itemDescription,
      this.receiverImageUrl,
      this.itemUrl,
      this.paymentStatus,
      this.chargeAmount,
      this.orderStatus,
      this.trackState,
      this.pickUpAddress,
      this.destinationAddress,
      this.driverID,
      this.driverPhone,
      this.deliveryTimeStamp,
      this.deliveryDate});
}

class orderRequest {
  File receiverImage;
  File itemImage;
  String receiverPhone;
  String receiverInfo;
  String itemDescription;
  String streetHouseName;

  orderRequest({
    this.receiverImage,
    this.itemImage,
    this.receiverPhone,
    this.itemDescription,
    this.receiverInfo,
    this.streetHouseName,
  });
}

String getOrderID() {
  var random = Random.secure();
  var value = random.nextInt(9999);
  String stringValue = value.toString();
  return 'Order${stringValue}PR';
}

String getCreationDate() {
  String day = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();
  String year = DateTime.now().year.toString();
  String creatiomDate = '$day $month. $year';
  return creatiomDate;
}

class OrderNotification {
  String userID;
  String title;
  String body;
  Map driverInfo;
  String date;
  String timeStamp;

  OrderNotification(
      {this.userID,
      this.title,
      this.body,
      this.driverInfo,
      this.date,
      this.timeStamp});
}
