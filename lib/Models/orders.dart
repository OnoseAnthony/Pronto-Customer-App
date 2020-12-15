import 'dart:io';

class Order {
  String userID;
  String orderID;
  String referenceID;
  String date;
  String receiverInfo;
  String receiverPhone;
  String itemDescription;
  String receiverImageUrl;
  String itemUrl;
  bool paymentStatus;
  String chargeAmount;
  Map tripInfo;

  Order(
      {this.userID,
      this.orderID,
      this.referenceID,
      this.date,
      this.receiverInfo,
      this.receiverPhone,
      this.itemDescription,
      this.receiverImageUrl,
      this.itemUrl,
      this.paymentStatus,
      this.chargeAmount,
      this.tripInfo});
}

class OrderData {
  File receiverImage;
  File itemImage;
  String receiverPhone;
  String receiverInfo;
  String itemDescription;

  OrderData({
    this.receiverImage,
    this.itemImage,
    this.receiverPhone,
    this.itemDescription,
    this.receiverInfo,
  });
}
