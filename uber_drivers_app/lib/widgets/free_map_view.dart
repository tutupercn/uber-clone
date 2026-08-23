import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class FreeMapView extends StatelessWidget {
  const FreeMapView({
    super.key,
    this.latitude = 40.8269,
    this.longitude = 29.3747,
    this.zoom = 13,
    this.showLocationMarker = true,
  });

  final double latitude;
  final double longitude;
  final double zoom;
  final bool showLocationMarker;

  static final Uri _copyrightUrl =
      Uri.parse('https://www.openstreetmap.org/copyright');

  @override
  Widget build(BuildContext context) {
    final center = LatLng(latitude, longitude);

    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: zoom),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.kocaelitag.surucu',
          maxZoom: 19,
        ),
        if (showLocationMarker)
          MarkerLayer(
            markers: [
              Marker(
                point: center,
                width: 48,
                height: 48,
                child: const Icon(
                  Icons.location_pin,
                  size: 46,
                  color: Color(0xFF00A884),
                ),
              ),
            ],
          ),
        Positioned(
          right: 6,
          bottom: 6,
          child: Material(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () => launchUrl(_copyrightUrl),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Text(
                  '© OpenStreetMap katkıda bulunanlar',
                  style: TextStyle(fontSize: 10, color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
