import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/orders.dart';
import 'package:fronto/Screens/Dashboard/orderRequestSummary.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/dialogs.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';
import 'package:fronto/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  ScrollController controller;
  double size;

  OrderScreen({@required this.controller, @required this.size});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController itemController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController houseStreetNameController = TextEditingController();

  String _hintText;
  File _staticReceiverImage;
  File _staticItemImage;
  bool isItemImageLoading = false;
  bool isReceiverImageLoading = false;

  @override
  void dispose() {
    itemController.dispose();
    receiverPhoneController.dispose();
    receiverNameController.dispose();
    houseStreetNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _hintText = Provider.of<AppData>(context).destinationLocation != null
        ? Provider.of<AppData>(context).destinationLocation.placeName
        : "unknown location";

    return Material(
      elevation: 10,
      color: kWhiteColor,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      child: ListView(
        padding: EdgeInsets.only(top: widget.size * 0.04, left: 40, right: 40),
        controller: widget.controller,
        children: [
          buildTitlenSubtitleText(
              'Please add package description and receiver details',
              Colors.black,
              20,
              FontWeight.w600,
              TextAlign.start,
              null),
          SizedBox(
            height: 20,
          ),
          buildNonEditTextField(_hintText, null),
          SizedBox(
            height: 30,
          ),
          buildTextField(
              'House Number / Street Name', houseStreetNameController, false),
          SizedBox(
            height: 20,
          ),
          buildCustomListTile(
              getIcon(Icons.location_on_outlined, 25, Colors.grey[600]),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 3,
                    ),
                    buildTitlenSubtitleText('Location', Colors.black, 13,
                        FontWeight.bold, TextAlign.start, null),
                    buildTitlenSubtitleText(
                        Provider.of<AppData>(context).pickUpLocation != null
                            ? Provider.of<AppData>(context)
                                .pickUpLocation
                                .placeName
                            : "unknown location",
                        Colors.grey,
                        12,
                        FontWeight.normal,
                        TextAlign.start,
                        TextOverflow.visible),
                  ],
                ),
              ),
              Container(),
              5.0,
              true),
          SizedBox(
            height: 25,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Add an image of the item', 'itemImage'),
                SizedBox(
                  height: 15,
                ),
                buildTextField('Description', itemController, false),
                SizedBox(
                  height: 35,
                ),
                _buildRow('Image of receiver', 'receiverImage'),
                SizedBox(
                  height: 15,
                ),
                buildTextField(
                    'Name of receiver', receiverNameController, false),
                SizedBox(
                  height: 30,
                ),
                buildTextField(
                    'Phone number of receiver', receiverPhoneController, true),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              if (_formKey.currentState.validate() &&
                  _staticItemImage != null &&
                  _staticReceiverImage != null &&
                  Provider.of<AppData>(context, listen: false).pickUpLocation !=
                      null) {
                orderRequest orderData = orderRequest(
                  receiverImage: _staticReceiverImage,
                  itemImage: _staticItemImage,
                  receiverInfo: receiverNameController.text,
                  receiverPhone: receiverPhoneController.text,
                  itemDescription: itemController.text,
                  streetHouseName: houseStreetNameController.text,
                );

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderSummary()));

                Provider.of<AppData>(context, listen: false)
                    .updateOrderRequest(orderData);
              } else if (_staticItemImage == null)
                showToast(context, 'Please upload a clear photo of the item',
                    kErrorColor, true);
              else if (_staticReceiverImage == null)
                showToast(
                    context,
                    'Please upload a clear photo of the receiver',
                    kErrorColor,
                    true);
              else if (Provider.of<AppData>(context, listen: false)
                      .pickUpLocation ==
                  null)
                showToast(
                    context, 'Please enter pickup location', kErrorColor, true);
            },
            child: buildSubmitButton('SEND ITEM', 25.0, false),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _buildRow(
    String info,
    String label,
  ) {
    return InkWell(
      onTap: () async {
        if (label == 'receiverImage')
          setState(() {
            isReceiverImageLoading = true;
          });
        else
          setState(() {
            isItemImageLoading = true;
          });
        var tempImage = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 65);
        if (label == 'receiverImage') {
          setState(() {
            _staticReceiverImage = tempImage;
          });
        } else {
          setState(() {
            _staticItemImage = tempImage;
          });
        }
        setState(() {
          isItemImageLoading = false;
          isReceiverImageLoading = false;
        });
      },
      child: Row(
        children: [
          isReceiverImageLoading && label == 'receiverImage'
              ? Container(
                  height: 35,
                  width: 35,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ))
              : isItemImageLoading && label == 'itemImage'
                  ? Container(
                      height: 35,
                      width: 35,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ))
                  : label == 'receiverImage' && _staticReceiverImage != null
                      ? buildContainerImage(
                          _staticReceiverImage, Colors.grey[400])
                      : label == 'itemImage' && _staticItemImage != null
                          ? buildContainerImage(
                              _staticItemImage, Colors.grey[400])
                          : buildContainerIcon(
                              Icons.camera_alt,
                              label == 'receiverImage'
                                  ? Color(0xFF27AE60)
                                  : kPrimaryColor),
          SizedBox(
            width: 20,
          ),
          buildTitlenSubtitleText(
              info, Colors.black, 15, FontWeight.normal, TextAlign.start, null),
        ],
      ),
    );
  }
}
