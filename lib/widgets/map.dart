import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geodesy/geodesy.dart';
import 'bubble.dart';

class BubbleData {
  final LatLng coords;
  final IconData icon;
  final String description;

  BubbleData(this.coords, this.icon, this.description);
}

final bubblePoints = [
  BubbleData(LatLng(3.217328686336803, 101.72784866117381), Icons.menu_book_sharp, "Library + iChill cafe"),
  BubbleData(LatLng(3.215970085230566, 101.72882998025881), Icons.sports_football, "TarUmt Arena + football field"),
  BubbleData(LatLng(3.2150895302002205, 101.72786087173617), Icons.sports_basketball, "Volleyball + basketball court"),
  BubbleData(LatLng(3.216026046983474, 101.7271112065123), Icons.location_city_outlined, "Block c"),
  BubbleData(LatLng(3.213909932070623, 101.72660635513168), Icons.computer, "Citc + FM cafe"),
  BubbleData(LatLng(3.215035508428385, 101.72840023753275), Icons.door_sliding, "Main entrance"),
  BubbleData(LatLng(3.215522706847166, 101.72666678121772), Icons.location_city_outlined, "Block b + Cisco lab"),
  BubbleData(LatLng(3.21593422992443, 101.72785803309898), Icons.fork_left, "Yum Yum canteen + Block L"),
  BubbleData(LatLng(3.2168547724713217, 101.72774363042564), Icons.location_city_outlined, "Block M"),
  BubbleData(LatLng(3.216189175467243, 101.7266712282868), Icons.account_tree, "The Rimba"),
  BubbleData(LatLng(3.216153357152101, 101.72548189956014), Icons.rice_bowl, "RedBricks cafeteria + BilaBila mart"),
  BubbleData(LatLng(3.216793608481452, 101.7251112453148), Icons.location_city_outlined, "Block K"),
  BubbleData(LatLng(3.216477608664624, 101.72492801980371), Icons.door_sliding, "Entrance gate 3"),
  BubbleData(LatLng(3.2147357410725097, 101.72608039376028), Icons.location_city_outlined, "Building Tan"),
  BubbleData(LatLng(3.2144113054145853, 101.7271583799657), Icons.emoji_transportation, "排长龙的bus stop"),
];

class MapView extends StatefulWidget {
  final fmap.MapController? controller;

  const MapView({super.key, this.controller});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final fmap.MapController mapController = fmap.MapController();
  double mapZoom = 18; // zoom at start
  fmap.LatLngBounds? currentBounds; // within camera view, wait until bounds exist
  LatLng? lastCenter;

  double zoomedBubbleSize(double zoom) {
    if (zoom >= 19) return 150;
    if (zoom >= 18) return 110;
    if (zoom >= 17) return 80;
    return 40;
  }

  @override
  Widget build(BuildContext context) {
    return fmap.FlutterMap(
      mapController: widget.controller,
      options: fmap.MapOptions(
        initialCenter: LatLng(3.214973, 101.728433),
        initialZoom: 18,
        minZoom: 17,
        maxZoom: 19,
        onPositionChanged: (pos, _) {
          final movedFar = lastCenter == null
              ? true
              : Geodesy().distanceBetweenTwoGeoPoints(
            LatLng(lastCenter!.latitude, lastCenter!.longitude),
            LatLng(pos.center.latitude, pos.center.longitude),
          ) > 80; // threshold in meters

          final zoomChanged = (pos.zoom - mapZoom).abs() > 0.1;

          if (movedFar || zoomChanged) {
            setState(() {
              mapZoom = pos.zoom;
              currentBounds = pos.visibleBounds;
              lastCenter = pos.center;
            });
          }
        },
      ),
      children: [
        fmap.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.testflutter',
        ),
        CurrentLocationLayer(),
        fmap.MarkerLayer( //! tooltip: "tracing..."
            markers: bubblePoints
                .where((bubble) => currentBounds?.contains(bubble.coords) ?? false) // hide bubble if not on screen
                .map((bubble){
              return fmap.Marker(
                point: bubble.coords,
                width: zoomedBubbleSize(mapZoom), // bubble size according to map bounds
                height: zoomedBubbleSize(mapZoom),
                child: GestureDetector(
                  onLongPress: () {
                    //! trace
                  },
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                  child: FloatingBubble(icon: Icon(bubble.icon), shrink: false, zoom: mapZoom, description: bubble.description),
                  ),
                ),
                alignment: Alignment.center,
              );
        }).toList(),
          rotate: false,
        ),
        fmap.RichAttributionWidget(
            attributions: [
              fmap.TextSourceAttribution(
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
