import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'pages/home.dart';

Future<void> requestPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensures plugins are ready
  await requestPermission();
  runApp(const MApp());
}

class MApp extends StatelessWidget {
  const MApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        // This is the theme of your application.
        colorScheme: ColorScheme.dark(),
      ),
      home: const MyHomePage(title: 'Interactive MApp'),
    );
  }
}

