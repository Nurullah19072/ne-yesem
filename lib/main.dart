import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpinWheelApp(),
    );
  }
}

class SpinWheelApp extends StatefulWidget {
  @override
  _SpinWheelAppState createState() => _SpinWheelAppState();
}

class _SpinWheelAppState extends State<SpinWheelApp> {
  final List<String> _meals = ["Pizza", "Burger","Çiğköfte","Donas","Köfte","missos","kadıköy","Beyoğlu","tolga döner"];
  final Random _random = Random();
  final StreamController<int> _controller = StreamController<int>();

  int _selected = 0;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _addMeal(String meal) {
    setState(() {
      _meals.add(meal);
    });
  }

  void _spinWheel() {
    setState(() {
      _selected = _random.nextInt(_meals.length);
    });
    _controller.add(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yemek Çarkı'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FortuneWheel(
              selected: _controller.stream,
              items: [
                for (var meal in _meals)
                  FortuneItem(child: Text(meal)),
              ],
              onAnimationEnd: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Seçilen yemek: ${_meals[_selected]}')),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _spinWheel,
              child: Text('Çarkı Çevir'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Yeni Yemek Ekle',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _addMeal(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
