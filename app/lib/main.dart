import 'package:app/models/constants.dart';
import 'package:app/pages/map_page.dart';
import 'package:flutter/material.dart';

void main() {
  // Do Not add const here, the map page won't respond to to gestures or move in any way.
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  MapMode _mapMode = MapMode.normal;

  void _switchMode(int index) {
    setState(() {
      _mapMode = MapMode.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(
          child: Scaffold(
        body: MapPage(
          mapMode: _mapMode,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Contribute")
          ],
          currentIndex: _mapMode.index,
          onTap: _switchMode,
        ),
      )),
    );
  }
}
