import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/orders.dart';
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
  FirebaseFirestore.instance.collection('CustomUser');

  //collection reference for orders
  final CollectionReference userOrderCollection =
  FirebaseFirestore.instance.collection('Orders');

  Future updateUserProfileData(bool isDriver, String fName, String lName,
      String photoUrl) async {
    CustomUser customUser = CustomUser(
      uid: firebaseUser.uid,
      isDriver: isDriver,
      fName: fName,
      lName: lName,
      photoUrl: photoUrl,
    );
    Provider.of<AppData>(context, listen: false).updateUserInfo(customUser);
    return await userProfileCollection.doc(firebaseUser.uid).set({
      'uid': firebaseUser.uid,
      'isDriver': isDriver,
      'fName': fName,
      'lName': lName,
      'photoUrl': photoUrl
    });
  }

  // Function to check if the uid exists in the firestore custom user collection
  Future<bool> checkUser() async {
    var document = await userProfileCollection.doc(firebaseUser.uid).get();
    if (document.exists)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // Function to check if the isDriver Field is true of false in the firestore custom user collection
  Future<bool> checkUserIsDriver() async {
    DocumentSnapshot document =
    await userProfileCollection.doc(firebaseUser.uid).get();
    bool isDriver = document.get('isDriver');
    if (isDriver == true)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // method to return custom user data object from snapshot
  CustomUser _customUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser.fromMap(snapshot.data());
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
      'stateName': pickUpLocation.stateName
    };

    Map destinationLocationMap = {
      'latitude': destinationLocation.latitude,
      'longitude': destinationLocation.longitude,
      'stateName': destinationLocation.stateName
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
      });

      print(
          'We\'re in the try block **********************************************************************************************************************************************************should work');
      return Future.value(true);
    } catch (e) {
      print(
          print(e.toString());
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
}
