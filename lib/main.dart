import 'package:animation_practice1/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Helvetica', // 👈 This applies Helvetica app-wide
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontWeight: FontWeight.normal),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
