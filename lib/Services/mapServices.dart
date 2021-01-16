import 'package:fronto/DataHandler/appData.dart';
import 'package:fronto/Models/address.dart';
import 'package:fronto/Models/directions.dart';
import 'package:fronto/Services/requestAssistant.dart';
import 'package:fronto/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String state = '';

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$kMapKey";

    var _response = await RequestAssistant.getRequest(url);

    if (_response != 'Failed') {
      placeAddress = _response["results"][0]["formatted_address"];

      List components = _response["results"][0]["address_components"];
      for (int i = 0; i < components.length; i++) {
        if (components[i]["types"][0] == 'administrative_area_level_1') {
          state = components[i]["long_name"];
          break;
        }
      }

      Address userPickupAddress = Address(
        placeName: placeAddress,
        stateName: state,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );

      Provider.of<AppData>(context, listen: false)
          .updatePickupLocationAddress(userPickupAddress);
    } else {
      placeAddress = "We couldn\'t find your results at this time";
      Address userPickupAddress = Address(
        placeName: placeAddress,
        stateName: state,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );

      Provider.of<AppData>(context, listen: false)
          .updatePickupLocationAddress(userPickupAddress);
    }

    return placeAddress;
  }

  static Future<Directions> getDirections(
      LatLng pickUp, LatLng destination) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${pickUp.latitude},${pickUp.longitude}&destination=${destination.latitude},${destination.longitude}&key=$kMapKey";

    var _response = await RequestAssistant.getRequest(url);


    if (_response == 'Failed') return null;

    Directions directions = Directions(
      distanceValue: _response["routes"][0]["legs"][0]["distance"]["value"],
      durationValue: _response["routes"][0]["legs"][0]["duration"]["value"],
      distanceText: _response["routes"][0]["legs"][0]["distance"]["text"],
      durationText: _response["routes"][0]["legs"][0]["duration"]["text"],
      encodedPoints: _response["routes"][0]["overview_polyline"]["points"],
    );


    return directions;
  }

  static int calculateFare(context, Directions directions, bool isExpress) {
    double fare;
    final pricePerMinute = 4;
    final pricePerKm = 44.4;
    final baseFare = 200;

    final expressPricePerMinute = 4;
    final expressPricePerKm = 66.6;
    final expressBaseFare = 300;

    //charging N4 per minute for the total time traveled
    //charging N44.4 per kilometre for total kilometre traveled
    //base fare N200

    //charging N4 per minute for the total time traveled --EXPRESS DELIVERY
    //charging N66.6 per kilometre for total kilometre traveled --EXPRESS DELIVERY
    //base fare N300 --EXPRESS DELIVERY

    if (isExpress) {
      double timeTraveledFare =
          (directions.durationValue / 60) * expressPricePerMinute;
      double distanceTraveledFare =
          (directions.distanceValue / 1000) * expressPricePerKm;
      fare = timeTraveledFare + distanceTraveledFare + expressBaseFare;
    } else {
      double timeTraveledFare =
          (directions.durationValue / 60) * pricePerMinute;
      double distanceTraveledFare =
          (directions.distanceValue / 1000) * pricePerKm;
      fare = timeTraveledFare + distanceTraveledFare + baseFare;
    }
    return fare.truncate();
  }
}
