
import 'package:flutter/material.dart';
import 'package:projeto1/app/view/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyDogs',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: ListViewDog());
  }
}