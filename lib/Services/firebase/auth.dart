import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/users.dart';
import 'package:fronto/Screens/Dashboard/DrawerScreens/editProfile.dart';
import 'package:fronto/Screens/onboarding/verifyPhoneNumber.dart';
import 'package:fronto/Screens/wrapper.dart';
import 'package:fronto/Services/firebase/firestore.dart';
import 'package:fronto/Services/firebase/pushNotificationService.dart';
import 'package:fronto/SharedWidgets/dialogs.dart';
import 'package:fronto/constants.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future createUserWithPhoneAuth(
      String phoneNumber, BuildContext context) async {
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.pop(context);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => NavigationLoader(context),
          );

          UserCredential result = await auth.signInWithCredential(credential);

          User user = result.user;

          if (user != null &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkUser() !=
                  true &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkRider() !=
                  true) {
            //New user so we create an instance

            //create an instance of the database service to create customer profile

            showToast(context, 'Authentication Successful. Please wait',
                kPrimaryColor, false);


            //provide the user info to the provider
            Provider.of<AppData>(context, listen: false)
                .updateFirebaseUser(user);

            //GOTO PROFILE SCREEN
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => EditProfile(isFromAuth: true,)));
          } else if (user != null &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkUser() ==
                  true) {
            CustomUser _customUser = await DatabaseService(
                    firebaseUser: getCurrentUser(), context: context)
                .getCustomUserData();

            await DatabaseService(
                    firebaseUser: getCurrentUser(), context: context)
                .updateUserProfileData(
                    _customUser.fName,
                    _customUser.lName,
                    _customUser.photoUrl,
                    await NotificationService(context: context)
                        .getTokenString());

            //returning user found in the customer collection, we show toast and then navigate to home screen
            showToast(context, 'Authentication Successful. Please wait',
                kPrimaryColor, false);

            //provide the user info to the provider
            Provider.of<AppData>(context, listen: false)
                .updateFirebaseUser(user);

            //check if user has profile  set up
            if (_customUser == null)
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EditProfile(isFromAuth: true,)));
            else
              //GOTO HOME SCREEN
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Wrapper()));
          } else if (user != null &&
              await DatabaseService(firebaseUser: user, context: context)
                      .checkRider() ==
                  true) {

            //Since user is found in the rider collection and we are on the customer app we assume the rider wants to register as a customer so we create an instance of the database service to create customer profile

            showToast(context, 'Authentication Successful. Please wait',
                kPrimaryColor, false);


            //provide the user info to the provider
            Provider.of<AppData>(context, listen: false)
                .updateFirebaseUser(user);

            //GOTO PROFILE SCREEN
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => EditProfile(isFromAuth: true,)));
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          Navigator.pop(context);
          showToast(
              context, 'Authentication Failed. Try Later', kErrorColor, false);
        },
        codeSent: (String verificationID, [int forceResendingToken]) {
          //pop the dialog before navigating
          Navigator.pop(context);

          //NAVIGATE TO THE SCREEN WHERE THEY CAN ENTER THE CODE SENT

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyPhone(
                        phoneNumber: phoneNumber,
                        verificationId: verificationID,
                        auth: auth,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<bool> updateUserEmailAddress(String emailAddress, context) async {
    User user = auth.currentUser;
    if (user != null)
      try {
        await user.updateEmail(emailAddress);
        Provider.of<AppData>(context, listen: false).updateFirebaseUser(user);
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
  }

  User getCurrentUser() {
    return auth.currentUser;
  }

  Future<bool> signOut() async {
    User user = auth.currentUser;
    if (user != null)
      try {
        await auth.signOut();
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
  }
}
