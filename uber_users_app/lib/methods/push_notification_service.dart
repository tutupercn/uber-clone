import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/config/app_config.dart';

class PushNotificationService {
  static Future<void> sendNotificationToSelectedDriver(
    String deviceToken,
    BuildContext context,
    String tripID,
  ) async {
    if (AppConfig.backendBaseUrl.isEmpty) {
      throw StateError('BACKEND_BASE_URL yapılandırılmamış.');
    }
    final appInfo = Provider.of<AppInfoClass>(context, listen: false);
    final response = await http.post(
      Uri.parse('${AppConfig.backendBaseUrl}/notifyDriver'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceToken': deviceToken,
        'tripId': tripID,
        'pickupAddress': appInfo.pickUpLocation?.placeName ?? '',
        'dropoffAddress': appInfo.dropOffLocation?.placeName ?? '',
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Sürücü bildirimi gönderilemedi (${response.statusCode}).');
    }
  }
}
