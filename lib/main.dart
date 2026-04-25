import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const CalculatorApp(),
    ),
  );
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  // This widget is the root of your application.
  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  static const _defaultCustomColor = Color(0xFF64412c);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme = ColorScheme.fromSeed(
          seedColor: _defaultCustomColor,
          brightness: Brightness.light,
        );

        ColorScheme darkScheme = ColorScheme.fromSeed(
          seedColor: _defaultCustomColor,
          brightness: Brightness.dark,
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: _themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightScheme,
            textTheme: GoogleFonts.openSansTextTheme(),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkScheme,
            textTheme: GoogleFonts.openSansTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
          ),
          home: CalculatorMainScreen(onThemeToggle: toggleTheme),
        );
      },
    );
  }
}

class CalculatorMainScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const CalculatorMainScreen({super.key, required this.onThemeToggle});

  @override
  State<CalculatorMainScreen> createState() => _CalculatorMainScreenState();
}

class _CalculatorMainScreenState extends State<CalculatorMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter 1st Num"),
            TextFormField(
              decoration: InputDecoration(labelText: "This is a TextField"),
            ),
            Text("Enter 2nd Num"),
            TextFormField(
              decoration: InputDecoration(labelText: "This is a TextField"),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Get Result')),
          ],
        ),
      ),
    );
  }
}
