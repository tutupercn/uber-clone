import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapCoordinate {
  const MapCoordinate(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  LatLng toLatLng() => LatLng(latitude, longitude);
}

class FreeMapView extends StatelessWidget {
  const FreeMapView({
    super.key,
    this.latitude = 40.8269,
    this.longitude = 29.3747,
    this.zoom = 13,
    this.showLocationMarker = true,
    this.pickup,
    this.dropoff,
    this.route = const [],
  });

  final double latitude;
  final double longitude;
  final double zoom;
  final bool showLocationMarker;
  final MapCoordinate? pickup;
  final MapCoordinate? dropoff;
  final List<MapCoordinate> route;

  static final Uri _copyrightUrl =
      Uri.parse('https://www.openstreetmap.org/copyright');

  @override
  Widget build(BuildContext context) {
    final center = LatLng(latitude, longitude);

    return FlutterMap(
      key: ValueKey('$latitude,$longitude,$zoom'),
      options: MapOptions(initialCenter: center, initialZoom: zoom),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.kocaelitag.yolcu',
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
        if (route.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route.map((point) => point.toLatLng()).toList(),
                color: const Color(0xFF00A884),
                strokeWidth: 5,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (pickup != null)
              Marker(
                point: pickup!.toLatLng(),
                width: 42,
                height: 42,
                child: const Icon(
                  Icons.trip_origin,
                  color: Colors.green,
                  size: 34,
                ),
              ),
            if (dropoff != null)
              Marker(
                point: dropoff!.toLatLng(),
                width: 42,
                height: 42,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
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
