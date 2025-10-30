import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:geodesy/geodesy.dart';
import 'dart:convert';
import 'bubble.dart';

class BubbleData {
  final LatLng coords;
  final IconData icon;
  final String meta;
  bool highlight;
  final String description;

  BubbleData(this.coords, this.icon, this.meta, this.highlight, this.description);
}

Future<(double, List<LatLng>)> getOsrmDistance(LatLng start, LatLng end) async {
  //! limit to 2 request per min
  final url = Uri.parse(
      'https://routing.openstreetmap.de/routed-foot/route/v1/foot/'
          '${start.longitude},${start.latitude};${end.longitude},${end
          .latitude}'
          '?overview=full&geometries=geojson'
  );

  final response = await http.get(url);
  if(response.statusCode != 200) throw Exception('OSRM failed: ${response.statusCode}');

  final data = jsonDecode(response.body);
  if (data['routes'].isEmpty) throw Exception('No route found');

  final distance = (data['routes'][0]['distance'] as num).toDouble();

  final route = data['routes'][0];
  final List coords = route['geometry']['coordinates'];
  final List<LatLng> routeCoords = coords.map((c) => LatLng(c[1], c[0])).toList();

  return (distance, routeCoords);
}

// list of locations
final bubblePoints = [
  BubbleData(LatLng(3.217328686336803, 101.72784866117381), Icons.menu_book_sharp, "Library + iChill cafe", false, "description"),
  BubbleData(LatLng(3.215945761567775, 101.72804643558223), Icons.food_bank, "YUM YUM Cafe", false, "description"),
  BubbleData(LatLng(3.216206763171565, 101.72694772473982), Icons.park, "The RIMBA", false, "description"),
  BubbleData(LatLng(3.2169726663959515, 101.72665268176314), Icons.apartment, "Block D", false, "description"),
  BubbleData(LatLng(3.2162281870457994, 101.72557443379377), Icons.food_bank, "Red Bricks", false, "description"),
  BubbleData(LatLng(3.216758427789753, 101.72511845828434), Icons.book, "Block K", false, "description"),
  BubbleData(LatLng(3.2177385690746174, 101.72643274071962), Icons.apartment, "Block P", false, "description"),
  BubbleData(LatLng(3.2179206717176507, 101.72779530283015), Icons.apartment, "Block R", false, "description"),
  BubbleData(LatLng(3.2182206054117013, 101.72723203896557), Icons.apartment, "Block Q Goh Pet House", false, "description"),
  BubbleData(LatLng(3.2181349100795567, 101.72841757529007), Icons.apartment, "DK D", false, "description"),
  BubbleData(LatLng(3.217749280995691, 101.72825664275734), Icons.apartment, "DK Y", false, "description"),
  BubbleData(LatLng(3.21818311370476, 101.72991961226231), Icons.sports_tennis, "Sports Complex", false, "description"),
  BubbleData(LatLng(3.217690365428371, 101.72981232390714), Icons.pool_outlined, "Swimming Pool", false, "description"),
  BubbleData(LatLng(3.217256532504462, 101.73041850319181), Icons.apartment, "Block X", false, "description"),
  BubbleData(LatLng(3.2168816150184636, 101.73021465531703), Icons.apartment, "Block W", false, "description"),
  BubbleData(LatLng(3.2164370698206803, 101.72939926381781), Icons.apartment, "DTAR", false, "description"),
  BubbleData(LatLng(3.2148409902509747, 101.72784358267941), Icons.directions_bus, "CITC Bus Stop", false, "description"),
  BubbleData(LatLng(3.215452207516076, 101.72594558444176), Icons.apartment, "Block H", false, "description"),
  BubbleData(LatLng(3.2165394693927305, 101.72513019294445), Icons.apartment, "Gate 3", false, "description"),
  BubbleData(LatLng(3.216668012599776, 101.72558616845905 ), Icons.apartment, "DK B", false, "description"),
  BubbleData(LatLng(3.2170107943784796, 101.72601532187967), Icons.apartment, "DK 6", false, "description"),
  BubbleData(LatLng(3.216689436467496, 101.7272437735957), Icons.apartment, "DK A", false, "description"),
  BubbleData(LatLng(3.217449983367184, 101.72694336620127), Icons.apartment, "Block N", false, "description"),
  BubbleData(LatLng(3.216748352092677, 101.72775339328271), Icons.apartment, "Block M", false, "description"),
  BubbleData(LatLng(3.216957234728746, 101.72679316254049), Icons.apartment, "Block D", false, "description"),
  BubbleData(LatLng(3.2162127553565463, 101.72784458844494), Icons.apartment, "Block L", false, "description"),
  BubbleData(LatLng(3.2152808163694746, 101.72925543036474), Icons.directions_bus, "Bus Stop", false, "description"),
  BubbleData(LatLng(3.21542542765268, 101.73125635824827), Icons.apartment, "DK ABA", false, "description"),
  BubbleData(LatLng(3.2151951207997427, 101.73097204410708 ), Icons.apartment, "DK ABB", false, "description"),
  BubbleData(LatLng(3.215532547101455, 101.73145484170531), Icons.apartment, "DK ABC", false, "description"),
  BubbleData(LatLng(3.2158271255357342, 101.73161577426959), Icons.apartment, "DK ABD", false, "description"),
  BubbleData(LatLng(3.2160384150912513, 101.73183136808524), Icons.apartment, "DK ABE", false, "description"),
  BubbleData(LatLng(3.216187043236323, 101.73189775275291), Icons.apartment, "DK ABF", false, "description"),
  BubbleData(LatLng(3.2167437290923915, 101.73274868356806), Icons.directions_bus, "East Bus Stop", false, "description"),
  BubbleData(LatLng(3.217440004407951, 101.73269503939049), Icons.bed, "Hostel", false, "description"),
  BubbleData(LatLng(3.2164063031914543, 101.73353188856072), Icons.chrome_reader_mode_outlined, "DK SB + Study Room", false, "description"),
  BubbleData(LatLng(3.216042097331807, 101.73387521129725), Icons.menu_book_sharp, "FAFB", false, "description"),
  BubbleData(LatLng(3.216267048025193, 101.73390739780379), Icons.apartment, "Block SA", false, "description"),
  BubbleData(LatLng(3.2161545726846956, 101.73455112793475), Icons.apartment, "Block SG", false, "description"),
  BubbleData(LatLng(3.216797288748931, 101.73368209225796), Icons.apartment, "Block SC", false, "description"),
  BubbleData(LatLng(3.2170115273469624, 101.73422389845152), Icons.apartment, "Block SD", false, "description"),
  BubbleData(LatLng(3.2167812208522566, 101.73451894142819 ), Icons.apartment, "Block SE", false, "description"),
  BubbleData(LatLng(3.2173810888533656, 101.7304956280086), Icons.apartment, "Block X", false, "description"),
  BubbleData(LatLng(3.2179273968764575, 101.73058145869274), Icons.menu_book_sharp, "Fernhouse", false, "description"),
  BubbleData(LatLng(3.2172645664443964, 101.72972716384724), Icons.menu_book_sharp, "RNJ Swimming Academy", false, "description"),
  BubbleData(LatLng(3.217269922407452, 101.72999270252627), Icons.sports_gymnastics, "Clubhouse + Karaoke + GYM", false, "description"),
  BubbleData(LatLng(3.216996768256312, 101.73029310992071), Icons.apartment, "DK E", false, "description"),
  BubbleData(LatLng(3.2174707710013, 101.73013485959684), Icons.menu_book_sharp, "Canteen Swimming Pool", false, "description"),
  BubbleData(LatLng(3.2176676025985023, 101.7260009050347), Icons.apartment, "Block PA", false, "description"),
  BubbleData(LatLng(3.218219266429286, 101.72841489312293), Icons.apartment, "DK C", false, "description"),
  BubbleData(LatLng(3.2169207752180804, 101.72762271817815), Icons.mosque_outlined, "Surau", false, "description"),
  BubbleData(LatLng(3.217220709206396, 101.72709968744675), Icons.menu_book_sharp, "N102 Machining Lab", false, "description"),
  BubbleData(LatLng(3.2162646693019217, 101.72606971918097), Icons.apartment, "DK 4", false, "description"),
  BubbleData(LatLng(3.2164789080118825, 101.72606435476321), Icons.apartment, "DK 3", false, "description"),
  BubbleData(LatLng(3.2163396528555315, 101.72589001118607), Icons.apartment, "DK 2", false, "description"),
  BubbleData(LatLng(3.216433382289768, 101.72586318909728), Icons.apartment, "DK 1", false, "description"),
  BubbleData(LatLng(3.2159888368893577, 101.72705408984596), Icons.apartment, "Block C", false, "description"),
  BubbleData(LatLng(3.2155041214994653, 101.72663030084091), Icons.apartment, "Block B", false, "description"),
  BubbleData(LatLng(3.216264669295115, 101.72773537092486), Icons.apartment, "Block L", false, "description"),
  BubbleData(LatLng(3.215257746739027, 101.72665444071937 ), Icons.menu_book_sharp, "FOCS", false, "description"),
  BubbleData(LatLng(3.2152470347917577, 101.7264720505156 ), Icons.apartment, "Bangunan Tan Sri Khaw Kai Boh (Block A)", false, "description"),
  BubbleData(LatLng(3.213768784966854, 101.7271023695907), Icons.door_sliding, "Gate 2", false, "description"),
  BubbleData(LatLng(3.215091042038518, 101.72837708942367), Icons.door_sliding, "Main gate", false, "description"),
  BubbleData(LatLng(3.2149618344299093, 101.73017676917148 ), Icons.door_sliding, "Gate 4", false, "description"),
  BubbleData(LatLng(3.2148306130302036, 101.73052813853462), Icons.menu_book_sharp, "Tadika", false, "description"),
  BubbleData(LatLng(3.214560136213024, 101.73098679628339), Icons.apartment, "Block AA", false, "description"),
  BubbleData(LatLng(3.2147047475888857, 101.73016335815754), Icons.directions_bus, "Bus Stop", false, "description"),
  BubbleData(LatLng(3.215330125559735, 101.72925983427304), Icons.directions_bus, "Bus Stop", false, "description"),
  BubbleData(LatLng(3.213645670565849, 101.727130160289), Icons.directions_bus, "Bus Stop", false, "description"),
  BubbleData(LatLng(3.216470574800238, 101.73479252673384), Icons.apartment, "Block SF + Archi Student Parking", false, "description"),
  BubbleData(LatLng(3.216220902792959, 101.73548045585368), Icons.apartment, "PPU TAR College", false, "description"),
  BubbleData(LatLng(3.21585669684998, 101.73303964568089 ), Icons.door_sliding, "East Campus Gate", false, "description"),
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
  final campusBounds = fmap.LatLngBounds(
    const LatLng(3.211071019854526, 101.7230995276704),
    const LatLng(3.2219782726142223, 101.7378172058497)
  );
  LatLng? lastCenter;
  List<LatLng> _routeCoords = [];

  // don't request osm 20times per sec
  DateTime? _cooldownUntil;
  bool get _isOnCooldown => _cooldownUntil != null && DateTime.now().isBefore(_cooldownUntil!);


  double zoomedBubbleSize(double zoom) {
    if (zoom >= 19) return 150;
    if (zoom >= 18) return 110;
    if (zoom >= 17) return 80;
    return 40;
  }

  @override
  Widget build(BuildContext context) {

    final sortedBubbles = [...bubblePoints];
    sortedBubbles.sort((a, b){
      if(a.highlight && !b.highlight) return 1;
      if(!a.highlight && b.highlight) return -1;
      return 0;
    });

    return fmap.FlutterMap(
      mapController: widget.controller,
      options: fmap.MapOptions(
        initialCenter: LatLng(3.214973, 101.728433),
        interactionOptions: fmap.InteractionOptions(),
        initialZoom: 18,
        minZoom: 17,
        maxZoom: 20,
        cameraConstraint: fmap.CameraConstraint.contain(bounds: campusBounds),
        onPositionChanged: (pos, _) {
          final movedFar = lastCenter == null
              ? true
              : Geodesy().distanceBetweenTwoGeoPoints(
            LatLng(lastCenter!.latitude, lastCenter!.longitude),
            LatLng(pos.center.latitude, pos.center.longitude),
          ) > 80; // threshold in meters

          final zoomChanged = (pos.zoom - mapZoom).abs() > 0.5;

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
        if(_routeCoords.isNotEmpty)
          fmap.PolylineLayer(
            polylines: [
              fmap.Polyline(
                points: _routeCoords,
                strokeWidth: 3,
                color: Colors.blue.shade300,
              )
            ],
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
        ]),
        fmap.MarkerLayer( //! tooltip: "tracing..."
            markers: sortedBubbles
                .where((bubble) {
                  if(bubble.highlight) return true;
                  if (mapZoom < 17.5 && bubble.meta.contains('Parking')) return false;
                  if (mapZoom < 17 && bubble.meta.contains('Block')) return false;

                  return currentBounds?.contains(bubble.coords) ?? false; // hide bubble if not on screen
            })
                .map((bubble){
              return fmap.Marker(
                point: bubble.coords,
                width: zoomedBubbleSize(mapZoom), // bubble size according to map bounds
                height: zoomedBubbleSize(mapZoom),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: () async {
                    if(_isOnCooldown){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('chill bro - still on fetching cool-down')),
                      );
                      return;
                    }

                    // trace
                    final userPos = LatLng(3.214973, 101.728433); // main gate coords, change later
                    try{
                      for(var b in bubblePoints){
                        b.highlight = false;
                      }
                      bubble.highlight = true;
                      final (dist, route) = await getOsrmDistance(userPos, bubble.coords);
                      setState(() {
                        _routeCoords = route;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Distance: ${dist.toStringAsFixed(0)} meter(s)')),
                        );
                        _cooldownUntil = DateTime.now().add(const Duration(seconds: 20));
                      });
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Routing failed: $e')),
                      );
                      bubble.highlight = false;
                    }
                    },
                  child: OverflowBox(
                    maxWidth: double.infinity, // test changing size // make bubble glow when selected to trace
                    maxHeight: double.infinity,
                  child: FloatingBubble(key: ValueKey(bubble.meta), icon: Icon(bubble.icon), zoom: mapZoom, highlight: bubble.highlight, meta: bubble.meta, description: bubble.description),
                  ),
                ),
                alignment: Alignment.center,
              );
        }).toList(),
        ),
      ],
    );
  }
}
