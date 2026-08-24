import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/models/address_models.dart';

import '../models/direction_details.dart';

class CommonMethods {
  checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaySnackBar(
          "Your Internet is not Available. Check your connection. Try Again.",
          context);
    }
  }

  displaySnackBar(String messageText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static sendRequestToAPI(
    String apiUrl, {
    Map<String, String>? headers,
  }) async {
    http.Response responseFromAPI = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    try {
      if (responseFromAPI.statusCode == 200) {
        String dataFromApi = responseFromAPI.body;
        var dataDecoded = jsonDecode(dataFromApi);
        return dataDecoded;
      } else {
        print('error');
        return "error";
      }
    } catch (errorMsg) {
      print(errorMsg);
      return "error";
    }
  }

  ///Reverse GeoCoding
  static Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
      Position position, BuildContext context) async {
    String humanReadableAddress = "";
    String apiGeoCodingUrl =
        "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}&accept-language=tr";

    var responseFromAPI = await sendRequestToAPI(
      apiGeoCodingUrl,
      headers: const {
        'User-Agent': 'KocaeliTAG/1.0 (com.kocaelitag.yolcu)',
        'Accept-Language': 'tr',
      },
    );

    if (responseFromAPI != "error") {
      humanReadableAddress = responseFromAPI["display_name"] ?? "";

      AddressModel model = AddressModel();
      model.humanReadableAddress = humanReadableAddress;
      model.placeName = humanReadableAddress;
      model.longitudePosition = position.longitude;
      model.latitudePosition = position.latitude;

      Provider.of<AppInfoClass>(context, listen: false)
          .updatePickUpLocation(model);
    }

    return humanReadableAddress;
  }

  /// This method shortens the full address by extracting key parts.
  static String shortenAddress(String fullAddress) {
    // Split the address by commas
    List<String> parts = fullAddress.split(',');

    // Return a shorter version of the address: e.g., "Street Name, City"
    if (parts.length >= 2) {
      return "${parts[0].trim()}, ${parts[1].trim()}";
    }

    // If the address has fewer parts, return it as is
    return fullAddress;
  }

  static Future<DirectionDetails?> getDirectionDetailsFromAPI(
      LatLng source, LatLng destination) async {
    String urlDirectionAPI =
        "https://router.project-osrm.org/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=polyline&steps=false";

    var responseFromDirectionAPI = await sendRequestToAPI(
      urlDirectionAPI,
      headers: const {
        'User-Agent': 'KocaeliTAG/1.0 (com.kocaelitag.yolcu)',
      },
    );

    if (responseFromDirectionAPI == "error") {
      print("Error in response"); // Debugging: Log error
      return null;
    }

    if (responseFromDirectionAPI["routes"] == null ||
        responseFromDirectionAPI["routes"].isEmpty) {
      print("No routes found in the response.");
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    try {
      final route = responseFromDirectionAPI["routes"][0];
      final distanceMeters = (route["distance"] as num).round();
      final durationSeconds = (route["duration"] as num).round();
      directionDetails.distanceTextString =
          "${(distanceMeters / 1000).toStringAsFixed(1)} km";
      directionDetails.distanceValueDigit = distanceMeters;
      directionDetails.durationTextString =
          "${(durationSeconds / 60).ceil()} mins";
      directionDetails.durationValueDigit = durationSeconds;
      directionDetails.encodedPoints = route["geometry"];
    } catch (e) {
      print("Error processing response data: $e");
      return null;
    }
    return directionDetails;
  }

  calculateFareAmountInPKR(DirectionDetails directionDetails,
      {double surgeMultiplier = 1.0}) {
    double distancePerKmAmountPKR = 22;
    double durationPerMinuteAmountPKR = 2;
    double baseFareAmountPKR = 60;
    double bookingFeePKR = 10;
    double minimumFarePKR = 90;

    // Calculate fare based on distance and time
    double totalDistanceTravelledFareAmountPKR =
        (directionDetails.distanceValueDigit! / 1000) * distancePerKmAmountPKR;
    double totalDurationSpendFareAmountPKR =
        (directionDetails.durationValueDigit! / 60) *
            durationPerMinuteAmountPKR;

    // Total fare before applying surge
    double totalFareBeforeSurgePKR = baseFareAmountPKR +
        totalDistanceTravelledFareAmountPKR +
        totalDurationSpendFareAmountPKR +
        bookingFeePKR;

    // Apply surge pricing
    double overAllTotalFareAmountPKR =
        totalFareBeforeSurgePKR * surgeMultiplier;

    // Apply minimum fare
    if (overAllTotalFareAmountPKR < minimumFarePKR) {
      overAllTotalFareAmountPKR = minimumFarePKR;
    }

    return overAllTotalFareAmountPKR.toStringAsFixed(2);
  }

  // Utility function to format time from total minutes into "X hours Y mins"
  String formatTime(int totalMinutes) {
    int hours = totalMinutes ~/ 60; // Get the number of full hours
    int minutes = totalMinutes % 60; // Get the remaining minutes
    if (hours > 0) {
      return "$hours hours $minutes mins";
    } else {
      return "$minutes mins"; // If there are no hours, just show minutes
    }
  }
}
