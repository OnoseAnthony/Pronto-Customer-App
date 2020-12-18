import 'package:firebase_storage/firebase_storage.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:image_picker/image_picker.dart';
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
    print(
        'url is **************************************************************************************************************************************************8*$url');
    return url;
  } catch (error) {
    print(error.toString());
    throw error.toString();
  }
}

Future _getAndUploadImage(context) async {
  final uid = Provider.of<AppData>(context, listen: false).userInfo.uid;
  var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

  try {
    final Reference firebaseStorageReference =
        FirebaseStorage.instance.ref().child('profilepics/$uid.jpg');
    UploadTask task = firebaseStorageReference.putFile(tempImage);
    return await (await task.snapshot).ref.getDownloadURL();
  } catch (error) {
    print(error.toString());
    throw error.toString();
  }
}
