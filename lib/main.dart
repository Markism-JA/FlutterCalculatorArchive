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
  final _num1Controller = TextEditingController();
  final _num2Controller = TextEditingController();

  String _additionResult = "[Display result here]";
  String _subtractionResult = "[Display result here]";
  String _multiplicationResult = "[Display result here]";
  String _divisionResult = "[Display result here]";

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  void _calculateResults() {
    double? num1 = double.tryParse(_num1Controller.text);
    double? num2 = double.tryParse(_num2Controller.text);

    setState(() {
      if (num1 == null || num2 == null) {
        _additionResult = "Invalid Input";
        _subtractionResult = "Invalid Input";
        _multiplicationResult = "Invalid Input";
        _divisionResult = "Invalid Input";
        return;
      }

      _additionResult = (num1 + num2).toString();
      _subtractionResult = (num1 - num2).toString();
      _multiplicationResult = (num1 * num2).toString();

      if (num2 == 0) {
        _divisionResult = "Undefined (Div by 0)";
      } else {
        _divisionResult = (num1 / num2).toString();
      }
    });
  }

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
        child: Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Enter 1st num"),
              TextFormField(
                controller: _num1Controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "This is a TextField",
                ),
              ),
              const SizedBox(height: 20),
              const Text("Enter 2nd num"),
              TextFormField(
                controller: _num2Controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "This is a TextField",
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _calculateResults,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Get result',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  // 4. Pass the state variables into your UI
                  _buildResultRow("Addition", _additionResult),
                  _buildResultRow("Subtraction", _subtractionResult),
                  _buildResultRow("Multiplication", _multiplicationResult),
                  _buildResultRow("Division", _divisionResult),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            result,
            style: const TextStyle(
              color: Colors.blue,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
