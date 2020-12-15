import 'package:firebase_storage/firebase_storage.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

Future<String> _getAndUploadOrderImages(context, String name) async {
  final uid = Provider.of<AppData>(context, listen: false).userInfo.uid;
  final receiverImage =
      Provider.of<AppData>(context, listen: false).orderDatum.receiverImage;
  final itemImage =
      Provider.of<AppData>(context, listen: false).orderDatum.itemImage;
  String reference;
  var tempImage;
  if (name == 'receiverImage') {
    tempImage = receiverImage;
  } else {
    tempImage = itemImage;
  }

  try {
    final Reference firebaseStorageReference =
        FirebaseStorage.instance.ref().child('order/$uid/$reference/$name.jpg');
    UploadTask task = firebaseStorageReference.putFile(tempImage);
    return await (await task.snapshot).ref.getDownloadURL();
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
