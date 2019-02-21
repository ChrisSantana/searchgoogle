import 'package:flutter/material.dart';
import 'package:search_google/screen/home_screen.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        backgroundColor: Colors.grey[100],
        buttonColor: Colors.blue,
      ),
      title: 'Pesquisa Google',
      home: HomeScreen(),
    );
  }
}