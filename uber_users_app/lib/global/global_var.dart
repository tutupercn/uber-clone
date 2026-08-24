import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userEmail = "";
String userID = FirebaseAuth.instance.currentUser?.uid ?? "";
const String googleMapKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(40.8269, 29.3747),
  zoom: 14.4746,
);
