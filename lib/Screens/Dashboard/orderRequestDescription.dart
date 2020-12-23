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

  String _hintText;
  File _staticReceiverImage;
  File _staticItemImage;

  @override
  void dispose() {
    itemController.dispose();
    receiverPhoneController.dispose();
    receiverNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _hintText = Provider.of<AppData>(context).destinationLocation != null
        ? Provider.of<AppData>(context).destinationLocation.placeName
        : "unknown location";

    return Material(
      elevation: 10,
      color: Colors.white,
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
                buildTextField('Description', itemController),
                SizedBox(
                  height: 35,
                ),
                _buildRow('Image of receiver', 'receiverImage'),
                SizedBox(
                  height: 15,
                ),
                buildTextField('Name of receiver', receiverNameController),
                SizedBox(
                  height: 30,
                ),
                buildTextField(
                    'Phone number of receiver', receiverPhoneController),
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
                  _staticReceiverImage != null) {
                orderRequest orderData = orderRequest(
                  receiverImage: _staticReceiverImage,
                  itemImage: _staticItemImage,
                  receiverInfo: receiverNameController.text,
                  receiverPhone: receiverPhoneController.text,
                  itemDescription: itemController.text,
                );

                Provider.of<AppData>(context, listen: false)
                    .updateOrderRequest(orderData);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => OrderSummary()));
              } else if (_staticItemImage == null)
                showToast(context, 'Please upload a clear photo of the item',
                    Colors.red);
              else if (_staticReceiverImage == null)
                showToast(context,
                    'Please upload a clear photo of the receiver', Colors.red);
            },
            child: buildSubmitButton('SEND ITEM', 25.0),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _buildRow(String info, String label) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            var tempImage = await ImagePicker.pickImage(
                source: ImageSource.gallery);
            if (label == 'receiverImage') {
              setState(() {
                _staticReceiverImage = tempImage;
              });
            } else {
              setState(() {
                _staticItemImage = tempImage;
              });
            }
          },
          child: label == 'receiverImage' && _staticReceiverImage != null
              ? buildContainerImage(_staticReceiverImage)
              : label == 'itemImage' && _staticItemImage != null
              ? buildContainerImage(_staticItemImage)
              : buildContainerIcon(Icons.camera_alt),
        ),
        SizedBox(
          width: 20,
        ),
        buildTitlenSubtitleText(
            info, Colors.black, 15, FontWeight.normal, TextAlign.start, null),
      ],
    );
  }


}
