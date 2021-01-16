import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/orders.dart';
import 'package:fronto/Models/promotion.dart';
import 'package:fronto/Models/users.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/Services/firebase/storage.dart';
import 'package:fronto/Utils/enums.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  User firebaseUser;
  BuildContext context;

  DatabaseService({@required this.firebaseUser, this.context});

  //collection reference for user profile
  final CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('Customers');

  //collection reference for user profile
  final CollectionReference riderProfileCollection =
      FirebaseFirestore.instance.collection('Riders');

  //collection reference for orders
  final CollectionReference userOrderCollection =
      FirebaseFirestore.instance.collection('Orders');

  //collection reference for notifications
  final CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection('Notifications');

  //collection reference for promotions
  final CollectionReference promotionCollection =
      FirebaseFirestore.instance.collection('Promotions');

  //collection reference for orders
  final CollectionReference userSupportCollection =
      FirebaseFirestore.instance.collection('Support');

  Future<bool> updateUserProfileData(
      String fName, String lName, String photoUrl, String deviceToken) async {
    CustomUser customUser = CustomUser(
      uid: firebaseUser.uid,
      fName: fName,
      lName: lName,
      photoUrl: photoUrl,
    );
    try {
      await userProfileCollection.doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'fName': fName,
        'lName': lName,
        'emailAddress': firebaseUser.email,
        'phoneNumber': firebaseUser.phoneNumber,
        'photoUrl': photoUrl,
        'deviceToken': deviceToken,
      });
      Provider.of<AppData>(context, listen: false).updateUserInfo(customUser);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  // Function to check if the uid exists in the firestore customer collection
  Future<bool> checkUser() async {
    var document = await userProfileCollection.doc(firebaseUser.uid).get();
    if (document.exists)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // Function to check if the uid exists in the firestore rider collection
  Future<bool> checkRider() async {
    var document = await riderProfileCollection.doc(firebaseUser.uid).get();
    if (document.exists)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // method to return custom user data object from snapshot
  CustomUser _customUserDataFromSnapshot(DocumentSnapshot snapshot) {
    CustomUser customUser = CustomUser(
        uid: snapshot.get('uid'),
        fName: snapshot.get('fName'),
        lName: snapshot.get('lName'),
        photoUrl: snapshot.get('photoUrl'));
    Provider.of<AppData>(context, listen: false).updateUserInfo(customUser);
    return customUser;
  }

  // Function to get custom user data from firestore
  Future<CustomUser> getCustomUserData() async {
    DocumentSnapshot snapshot =
    await userProfileCollection.doc(firebaseUser.uid).get();
    return _customUserDataFromSnapshot(snapshot);
  }

  // Function to save order to database
  Future<bool> saveOrderRequest() async {
    var _firebaseUser = AuthService().getCurrentUser();
    var pickUpLocation =
        Provider
            .of<AppData>(context, listen: false)
            .pickUpLocation;
    var destinationLocation =
        Provider
            .of<AppData>(context, listen: false)
            .destinationLocation;
    var orderRequest =
        Provider
            .of<AppData>(context, listen: false)
            .orderRequestInfo;
    String paymentStatus =
        Provider
            .of<AppData>(context, listen: false)
            .paymentStatus;
    int chargeAmount =
        Provider
            .of<AppData>(context, listen: false)
            .chargeAmount;
    String paymentReference =
        Provider
            .of<AppData>(context, listen: false)
            .paymentReference;

    Map pickUpLocationMap = {
      'latitude': pickUpLocation.latitude,
      'longitude': pickUpLocation.longitude,
      'placeName': pickUpLocation.placeName,
      'stateName': pickUpLocation.stateName
    };

    Map destinationLocationMap = {
      'latitude': destinationLocation.latitude,
      'longitude': destinationLocation.longitude,
      'placeName': destinationLocation.placeName,
      'stateName': destinationLocation.stateName,
      'streetHouseName': orderRequest.streetHouseName,
    };

    String receiverImageUrl =
    await getAndUploadOrderImages(context, 'receiverImage');

    String itemImageUrl = await getAndUploadOrderImages(context, 'itemImage');

    try {
      await userOrderCollection.add({
        "userID": _firebaseUser.uid,
        "userPhone": _firebaseUser.phoneNumber,
        "orderID": getOrderID(),
        "paymentReferenceID": paymentReference.trim(),
        "date": getCreationDate(),
        "timeStamp": DateTime.now().toString(),
        "receiverInfo": orderRequest.receiverInfo.trim(),
        "receiverPhone": orderRequest.receiverPhone.trim(),
        "itemDescription": orderRequest.itemDescription.trim(),
        "receiverImageUrl": receiverImageUrl,
        "itemUrl": itemImageUrl,
        "paymentStatus": paymentStatus,
        "chargeAmount": chargeAmount,
        "orderStatus": OrderStatus.SUBMITTED.toString(),
        "trackState": 1,
        "pickUpAddress": pickUpLocationMap,
        "destinationAddress": destinationLocationMap,
        "driverID": '',
        "driverPhone": '',
        "deliveryTimeStamp": '',
        "deliveryDate": '',
      });

      return Future.value(true);
    } catch (e) {
          return Future.value(false);
    }
  }

  // method to return user order object from snapshot
  List<Order> userOrderFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Order(
        userID: doc.data()['userID'],
        userPhone: doc.data()['userPhone'],
        orderID: doc.data()['orderID'],
        paymentReferenceID: doc.data()['paymentReferenceID'],
        date: doc.data()['date'],
        timeStamp: doc.data()['timeStamp'],
        receiverInfo: doc.data()['receiverInfo'],
        receiverPhone: doc.data()['receiverPhone'],
        itemDescription: doc.data()['receiverInfo'],
        receiverImageUrl: doc.data()['itemDescription'],
        itemUrl: doc.data()['itemUrl'],
        paymentStatus: doc.data()['paymentStatus'],
        chargeAmount: doc.data()['chargeAmount'].toString(),
        orderStatus: doc.data()['orderStatus'],
        trackState: doc.data()['trackState'],
        pickUpAddress: doc.data()['pickUpAddress'],
        destinationAddress: doc.data()['destinationAddress'],
        deliveryDate: doc.data()['deliveryDate'],
      );
    }).toList();
  }

  // Function to get user orderOrders data from firestore
  Future<List<Order>> getUserOrderList() async {
    QuerySnapshot snapshot = await userOrderCollection
        .where("userID", isEqualTo: firebaseUser.uid)
        .orderBy('date', descending: true)
        .get();
    return (userOrderFromSnapshot(snapshot));
  }

  Future<bool> submitQuery(String title, String description) async {
    try {
      await userSupportCollection.add({
        "userID": firebaseUser.uid,
        "userPhone": firebaseUser.phoneNumber,
        "title": title,
        "description": description,
      });
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  // method to return notification from snapshot
  List<OrderNotification> notificationFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return OrderNotification(
        userID: doc.data()['userID'],
        title: doc.data()['title'],
        body: doc.data()['body'],
        driverInfo: doc.data()['driverInfo'],
        date: doc.data()['date'],
        timeStamp: doc.data()['timeStamp'],
      );
    }).toList();
  }

  //Stream to get all the notifications for a particular user
  Stream<List<OrderNotification>> get notificationStream {
    return notificationCollection
        .where('userID', isEqualTo: firebaseUser.uid)
        .orderBy("date", descending: true)
        .snapshots()
        .map(notificationFromSnapshot);
  }

  // method to return promotion from snapshot
  List<Promotion> promotionFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Promotion(
        title: doc.data()['title'],
        body: doc.data()['body'],
        imageUrl: doc.data()['imageUrl'],
      );
    }).toList();
  }

  //Stream to get all recently submitted promotions from firestore
  Stream<List<Promotion>> get promotionStream {
    return promotionCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(promotionFromSnapshot);
  }
}
