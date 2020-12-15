import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fronto/Screens/Dashboard/homeScreen.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/text.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitWanderingCubes(
      color: Colors.white,
      size: 50.0,
    );
  }
}

Dialog NavigationLoader(BuildContext context) {
  return Dialog(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.blue,
      ),
      height: 80.0,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoaderWidget(),
          ],
        ),
      ),
    ),
  );
}

Dialog ErrorDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    child: Container(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 5, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.info,
              color: Colors.red,
              size: 60,
            ),
            SizedBox(height: 15),
            buildTitlenSubtitleText(
                'Error occurred in processing payment',
                Colors.black,
                12,
                FontWeight.w600,
                TextAlign.start,
                TextOverflow.visible),
            SizedBox(
              height: 10,
            ),
            buildTitlenSubtitleText('Retry?', Colors.black, 12, FontWeight.w600,
                TextAlign.start, null),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'YES',
                    )),
                SizedBox(
                  width: 20,
                ),
                FlatButton(
                    textColor: Colors.white,
                    color: Colors.black54,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    },
                    child: Text('NO')),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

showToast(context, String msg, Color color) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color != null ? color : Colors.blue,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        getIcon(Icons.check, 20, Colors.white),
        SizedBox(
          width: 12.0,
        ),
        buildTitlenSubtitleText(
            msg, Colors.white, 14, FontWeight.normal, TextAlign.start, null)
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: Duration(seconds: 4),
  );

  // fToast.showToast(
  //     child: toast,
  //     toastDuration: Duration(seconds: 5),
  //     positionedToastBuilder: (context, child) {
  //       return Positioned(
  //         child: child,
  //         top: 40,
  //         left: MediaQuery.of(context).size.width * 0.20,
  //       );
  //     });
}
