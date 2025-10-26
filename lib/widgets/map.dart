import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatelessWidget {
  final Function(LatLng)? onTap; // optional callback

  const MapView({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(3.214973, 101.728433),
        initialZoom: 18,
        minZoom: 17,
        maxZoom: 19,
        onTap: (tapPosition, point) {
          if (onTap != null) onTap!(point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.testflutter',
        ),
        RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                  'OpenStreetMap contributors',
                onTap: () async {
                  final uri = Uri.parse('https://openstreetmap.org/copyright');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                }
              )
        ])
      ],
    );
  }
}
