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
          print('state is $state');
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

    print('This is the response i got from get directions Api $_response');

    if (_response == 'Failed') return null;

    Directions directions = Directions(
      distanceValue: _response["routes"][0]["legs"][0]["distance"]["value"],
      durationValue: _response["routes"][0]["legs"][0]["duration"]["value"],
      distanceText: _response["routes"][0]["legs"][0]["distance"]["text"],
      durationText: _response["routes"][0]["legs"][0]["duration"]["text"],
      encodedPoints: _response["routes"][0]["overview_polyline"]["points"],
    );

    print(
        'This is the api call response for distance value : ${_response["routes"][0]["legs"][0]["distance"]["value"]}');
    print(
        'This is the api call response for distance text : ${_response["routes"][0]["legs"][0]["distance"]["text"]}');
    print(
        'This is the api call response for duration text : ${_response["routes"][0]["legs"][0]["duration"]["text"]}');
    print(
        'This is the api call response for duration value : ${_response["routes"][0]["legs"][0]["duration"]["value"]}');
    print(
        'This is the api call response for encoded point : ${_response["routes"][0]["overview_polyline"]["points"]}');

    return directions;
  }

  static int calculateFare(context, Directions directions) {
    double fare;
    const exchangeRate = 500;

    //exchane rate is 1$ = NGN 500
    //charging $0.20 per minute for the total time traveled
    //charging $0.20 per kilometre for total kilometre traveled

    double timeTraveledFare = (directions.durationValue / 60) * 0.20;
    double distanceTraveledFare = (directions.distanceValue / 1000) * 0.20;
    fare = timeTraveledFare + distanceTraveledFare;

    //Can be converted to Naira here by multiplying exchage rate with calculated fare
    fare = fare * exchangeRate;

    Provider.of<AppData>(context, listen: false)
        .updateChargeAmount(fare.truncate());

    return fare.truncate();
  }
}
