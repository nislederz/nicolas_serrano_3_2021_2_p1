import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nicolas_serrano_3_2021_2_p1/screens/anime_list.dart';
import 'package:nicolas_serrano_3_2021_2_p1/screens/wait_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime App',
      home:  AnimeListScreen() 
    );
  }
}