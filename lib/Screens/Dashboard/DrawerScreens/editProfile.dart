import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/users.dart';
import 'package:fronto/Services/firebase/auth.dart';
import 'package:fronto/Services/firebase/firestore.dart';
import 'package:fronto/Services/firebase/pushNotificationService.dart';
import 'package:fronto/Services/firebase/storage.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/dialogs.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';
import 'package:fronto/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();

  File staticProfileImage;
  CustomUser customUser;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    customUser = Provider.of<AppData>(context, listen: false).userInfo;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.14),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery, imageQuality: 65);
                        setState(() {
                          staticProfileImage = image;
                        });
                      },
                      child: staticProfileImage == null &&
                              customUser != null &&
                              customUser.photoUrl != ''
                          ? Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: CachedNetworkImage(
                                imageUrl: customUser.photoUrl,
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColor),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            )
                          : staticProfileImage != null
                              ? buildContainerImage(
                                  staticProfileImage, Colors.grey[400])
                              : buildContainerIcon(Icons.person, kPrimaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildTitlenSubtitleText(
                        customUser != null
                            ? '${customUser.fName} ${customUser.lName}'
                            : 'Welcome, User',
                        Colors.black,
                        18,
                        FontWeight.w700,
                        TextAlign.center,
                        null),
                    SizedBox(
                      height: 50,
                    ),
                    buildTextField('First Name', firstNameController, false),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField('Last Name', lastNameController, false),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField(
                        AuthService().getCurrentUser().email ?? 'Email Address',
                        emailAddressController,
                        false),
                    SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState.validate() &&
                            staticProfileImage != null) {
                          showDialog(
                            context: context,
                            builder: (context) => NavigationLoader(context),
                          );

                          AuthService().updateUserEmailAddress(
                              emailAddressController.text.trim(), context);
                          bool isSubmitted = await DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .updateUserProfileData(
                                  firstNameController.text.trim() ??
                                      customUser.fName,
                                  lastNameController.text.trim() ??
                                      customUser.lName,
                                  await getAndUploadProfileImage(
                                      staticProfileImage),
                                  await NotificationService(context: context)
                                      .getTokenString());

                          if (isSubmitted) {
                            Navigator.pop(context);
                            showToast(context, 'profile updated successfully',
                                kPrimaryColor, false);
                          } else {
                            Navigator.pop(context);
                            showToast(
                                context,
                                'Error occurred. Try again later!!',
                                kErrorColor,
                                true);
                          }
                        } else if (_formKey.currentState.validate() &&
                            staticProfileImage == null) {
                          showDialog(
                            context: context,
                            builder: (context) => NavigationLoader(context),
                          );

                          AuthService().updateUserEmailAddress(
                              emailAddressController.text.trim(), context);
                          bool isSubmitted = await DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .updateUserProfileData(
                                  firstNameController.text.trim() ??
                                      customUser.fName,
                                  lastNameController.text.trim() ??
                                      customUser.lName,
                                  customUser.photoUrl,
                                  await NotificationService(context: context)
                                      .getTokenString());

                          if (isSubmitted) {
                            Navigator.pop(context);
                            showToast(context, 'profile updated successfully',
                                kPrimaryColor, false);
                          } else {
                            Navigator.pop(context);
                            showToast(
                                context,
                                'Error occurred. Try again later!!',
                                kErrorColor,
                                true);
                          }
                        }
                      },
                      child: buildSubmitButton('SAVE', 25.0, false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          getDrawerNavigator(context, size, 'Edit Profile'),
        ],
      ),
    );
  }
}
