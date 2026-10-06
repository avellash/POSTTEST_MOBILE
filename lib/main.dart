import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  // menjalankan aplikasi flutter.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // membuat konfigurasi utama aplikasi.
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'i-land 2 voting',

      theme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor:
        const Color(0xFF0B1026),

        fontFamily: 'Arial',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B7FFF),
          brightness: Brightness.dark,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1026),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        elevatedButtonTheme:
        ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            const Color(0xFF8B7FFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10),
            ),
          ),
        ),

        inputDecorationTheme:
        InputDecorationTheme(
          filled: true,
          fillColor:
          const Color(0xFF151B3D),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      // menentukan halaman pertama aplikasi.
      home: const HomePage(),
    );
  }
}