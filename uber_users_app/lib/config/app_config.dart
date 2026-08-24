import 'package:flutter/material.dart';

abstract final class AppConfig {
  static const appName = 'TAG Kocaeli';
  static const supportRegion = 'Kocaeli';
  static const primaryColor = Color(0xFF00A884);

  // Gizli anahtarlar mobil uygulamaya yazılmaz. Bildirim ve ödeme istekleri
  // Firebase Cloud Functions gibi güvenli bir sunucu üzerinden çalıştırılır.
  static const backendBaseUrl = String.fromEnvironment('BACKEND_BASE_URL');
  static const stripePublishableKey =
      String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
}
