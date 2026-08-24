import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../models/direction_details.dart';

class CommonMethods {
  Future<void> checkConnectivity(BuildContext context) async {
    var connectionResults = await Connectivity().checkConnectivity();
    print("Connectivity result: $connectionResults"); // Add this line

    if (connectionResults != ConnectivityResult.wifi &&
        connectionResults != ConnectivityResult.mobile) {
      if (!context.mounted) return;
      displaySnackBar(
          "Your internet is not working. Check your connection. Try again.",
          context);
    } else {
      print("Internet is working"); // Add this line
    }
  }

  void displaySnackBar(String message, BuildContext context) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void turnOffLocationUpdatesForHomePage() {
    if (positionStreamHomePage != null) {
      positionStreamHomePage!.pause();
    } else {
      // Handle the case where the stream is null (optional)
      print("positionStreamHomePage is null, cannot pause.");
    }
  }

  void turnOnLocationUpdatesForHomePage() {
    // Check if positionStreamHomePage is not null before resuming
    if (positionStreamHomePage != null) {
      positionStreamHomePage!.resume();
    } else {
      // Handle the case where the stream is null (optional)
      print("positionStreamHomePage is null, cannot resume.");
    }

    // Check if driverCurrentPosition is not null before updating Geofire
    if (driverCurrentPosition != null) {
      Geofire.setLocation(
        FirebaseAuth.instance.currentUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );
    } else {
      // Handle the case where driverCurrentPosition is null (optional)
      print("driverCurrentPosition is null, cannot update Geofire.");
    }
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
        return "error";
      }
    } catch (errorMsg) {
      return "error";
    }
  }

  /// OSRM route service used during development.
  static Future<DirectionDetails?> getDirectionDetailsFromAPI(
      LatLng source, LatLng destination) async {
    String urlDirectionsAPI =
        "https://router.project-osrm.org/route/v1/driving/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=polyline&steps=false";

    var responseFromDirectionsAPI = await sendRequestToAPI(
      urlDirectionsAPI,
      headers: const {
        'User-Agent': 'KocaeliTAG/1.0 (com.kocaelitag.surucu)',
      },
    );
    if (responseFromDirectionsAPI == "error") {
      return null;
    }

    if (responseFromDirectionsAPI["routes"] == null ||
        responseFromDirectionsAPI["routes"].isEmpty) {
      return null;
    }

    DirectionDetails detailsModel = DirectionDetails();
    final route = responseFromDirectionsAPI["routes"][0];
    final distanceMeters = (route["distance"] as num).round();
    final durationSeconds = (route["duration"] as num).round();
    detailsModel.distanceTextString =
        "${(distanceMeters / 1000).toStringAsFixed(1)} km";
    detailsModel.distanceValueDigits = distanceMeters;
    detailsModel.durationTextString =
        "${(durationSeconds / 60).ceil()} dk";
    detailsModel.durationValueDigits = durationSeconds;
    detailsModel.encodedPoints = route["geometry"];

    return detailsModel;
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
        (directionDetails.distanceValueDigits! / 1000) * distancePerKmAmountPKR;
    double totalDurationSpendFareAmountPKR =
        (directionDetails.durationValueDigits! / 60) *
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
}
