import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:uber_users_app/config/app_config.dart';

class StripePaymentService {
  Future<Map<String, dynamic>?> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    if (AppConfig.backendBaseUrl.isEmpty) {
      throw StateError('BACKEND_BASE_URL yapılandırılmamış.');
    }
    final response = await http.post(
      Uri.parse('${AppConfig.backendBaseUrl}/createPaymentIntent'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount, 'currency': currency}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Ödeme başlatılamadı (${response.statusCode}).');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> displayPaymentSheet(
    BuildContext context,
    String clientSecret,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ödeme başarıyla tamamlandı.')),
        );
      }
    } on StripeException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ödeme iptal edildi.')),
        );
      }
    }
  }

  Future<void> initPaymentSheet(
    BuildContext context,
    String clientSecret,
    String currency,
  ) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        googlePay: PaymentSheetGooglePay(
          testEnv: true,
          currencyCode: currency,
          merchantCountryCode: 'TR',
        ),
        merchantDisplayName: AppConfig.appName,
      ),
    );
  }
}
