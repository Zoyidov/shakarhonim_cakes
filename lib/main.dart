import 'package:flutter/material.dart';
import 'package:shakarhonim_cakes/presentation/home_page/home_page.dart';


void main() {
  runApp(const ShakarhonimApp());
}

class ShakarhonimApp extends StatelessWidget {
  const ShakarhonimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shakarhonim',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFAFC),
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF34FA1),
          background: const Color(0xFFFFFAFC),
        ),
      ),
      home: const ShakarhonimHomePage(),
    );
  }
}