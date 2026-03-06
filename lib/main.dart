import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro Personas',
      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {
        '/': (context) => RegisterScreen(),
        '/list': (context) => ListScreen(),
      },
    );
  }
}
