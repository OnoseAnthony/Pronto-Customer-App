class Address {
  String placeFormmatedAddress;
  String placeName;
  String placeId;
  String latitude;
  String longitude;

  Address(
      {this.placeFormmatedAddress,
      this.placeName,
      this.placeId,
      this.latitude,
      this.longitude});
}

class AddressPredictions {
  String place_id;
  String main_text;
  String secondary_text;

  AddressPredictions({this.place_id, this.main_text, this.secondary_text});

  AddressPredictions.FromJson(Map<String, dynamic> json) {
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }
}
