import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
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

