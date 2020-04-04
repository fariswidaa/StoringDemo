import 'package:flutter/material.dart';
import 'package:StoringDemo/ui/home.dart';

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Do it',
theme: ThemeData(
primarySwatch: Colors.purple,
canvasColor: Colors.transparent
),
//Our only screen/page we have
home: Home(),
);
}
}