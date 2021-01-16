import 'package:firebase_storage/firebase_storage.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:provider/provider.dart';

Future<String> getAndUploadOrderImages(context, String name) async {
  final uid = AuthService().getCurrentUser().uid;
  String reference =
      Provider.of<AppData>(context, listen: false).paymentReference;
  var tempImage;
  if (name == 'receiverImage') {
    tempImage = Provider.of<AppData>(context, listen: false)
        .orderRequestInfo
        .receiverImage;
  } else {
    tempImage =
        Provider.of<AppData>(context, listen: false).orderRequestInfo.itemImage;
  }

  try {
    final Reference firebaseStorageReference =
    FirebaseStorage.instance.ref().child('order/$uid/$reference/$name.jpg');


    UploadTask task = firebaseStorageReference.putFile(tempImage);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  } catch (error) {
    throw error.toString();
  }
}

Future<String> getAndUploadProfileImage(var tempImage) async {
  final uid = AuthService().getCurrentUser().uid;
  try {
    final Reference firebaseStorageReference =
        FirebaseStorage.instance.ref().child('profilepics/$uid.jpg');
    UploadTask task = firebaseStorageReference.putFile(tempImage);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  } catch (error) {
    print(error);
    throw error.toString();
  }
}
