import 'package:flutter/material.dart';
import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Screens/Dashboard/orderRequestSummary.dart';
import 'package:fronto/SharedWidgets/buttons.dart';
import 'package:fronto/SharedWidgets/customListTile.dart';
import 'package:fronto/SharedWidgets/text.dart';
import 'package:fronto/SharedWidgets/textFormField.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  ScrollController controller;
  double size;

  OrderScreen({@required this.controller, @required this.size});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController textController = TextEditingController();

  String _hintText;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _hintText = Provider.of<AppData>(context).destinationLocation != null
        ? Provider.of<AppData>(context).destinationLocation.placeName
        : "unknown location";
    print('This is _hintText $_hintText');
    return Material(
      elevation: 10,
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      child: ListView(
        padding: EdgeInsets.only(top: widget.size * 0.04, left: 40, right: 40),
        controller: widget.controller,
        children: [
          buildTitlenSubtitleText('Where do you want your package delivered?',
              Colors.black, 20, FontWeight.w600, TextAlign.start, null),
          SizedBox(
            height: 20,
          ),
          buildNonEditTextField(_hintText, () => Navigator.pop(context)),
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
              getIcon(Icons.edit, 20, Colors.black54),
              5.0,
              true),
          SizedBox(
            height: 25,
          ),
          _buildRow('Add an image of the item', null),
          SizedBox(
            height: 15,
          ),
          buildTextField('Description', textController),
          SizedBox(
            height: 35,
          ),
          _buildRow('Image of receiver', null),
          SizedBox(
            height: 15,
          ),
          buildTextField('Name of receiver', textController),
          SizedBox(
            height: 30,
          ),
          buildTextField('Phone number of receiver', textController),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OrderSummary()));
            },
            child: buildSubmitButton('PROCEED', 25.0),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _buildRow(String info, Function onTap) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: buildContainerIcon(Icons.camera_alt),
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
