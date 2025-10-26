import 'package:flutter/material.dart';
import '../widgets/bubble.dart';
import '../widgets/map.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(widget.title),
        toolbarHeight: 50,
      ),
      body: Stack(
        children: [
          MapView(
            onTap: (point){
              debugPrint("map tapped: $point");
            },
          ),
      Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            // The floating bubble lives here
            FloatingBubble(
              icon: Icon(Icons.menu_book_sharp),
              shrink: false,
              onScreen: true,
            ),
          ],
        ),
      )
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.grey[850],
        onTap: (index){
          // something
        },
        items: const[
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'HomeMap',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'chat',
          ),
        ],
      ),
    );
  }
}
