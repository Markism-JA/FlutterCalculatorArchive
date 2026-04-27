import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:advmobprog_prefinals_tp01_amarille/injection.dart';
import 'package:advmobprog_prefinals_tp01_amarille/service/calculator_service.dart';
import 'package:advmobprog_prefinals_tp01_amarille/widgets/calculator_button.dart';
import 'package:advmobprog_prefinals_tp01_amarille/widgets/calculator_display.dart';
import 'package:advmobprog_prefinals_tp01_amarille/widgets/calculator_keyboard.dart';
import 'package:advmobprog_prefinals_tp01_amarille/widgets/theme_switcher.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  try {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = const WindowOptions(
        size: Size(400, 750),
        minimumSize: Size(350, 600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
        title: 'Calculator App',
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  } catch (e) {
    // Ignore if running on Web or Mobile
  }

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
  ThemeMode _themeMode = ThemeMode.system;

  void setDarkMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  static const _defaultCustomColor = Color(0xFF2F3542);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme =
            lightDynamic ??
            ColorScheme.fromSeed(
              seedColor: _defaultCustomColor,
              brightness: Brightness.light,
            );

        ColorScheme darkScheme =
            darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: _defaultCustomColor,
              brightness: Brightness.dark,
            );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: _themeMode,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,

          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightScheme,
            textTheme: GoogleFonts.interTextTheme(),
            scaffoldBackgroundColor: lightScheme.surface,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkScheme,
            textTheme: GoogleFonts.interTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
            scaffoldBackgroundColor: darkScheme.surface,
          ),

          home: CalculatorMainScreen(
            onThemeToggle: setDarkMode,
            currentThemeMode: _themeMode,
          ),
        );
      },
    );
  }
}

class CalculatorMainScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeToggle;
  final ThemeMode currentThemeMode;

  const CalculatorMainScreen({
    super.key,
    required this.onThemeToggle,
    required this.currentThemeMode,
  });

  @override
  State<CalculatorMainScreen> createState() => _CalculatorMainScreenState();
}

class _CalculatorMainScreenState extends State<CalculatorMainScreen> {
  final CalculatorService _calculatorService = getIt<CalculatorService>();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyPress(String key) {
    setState(() {
      switch (key) {
        case 'AC':
          _calculatorService.clearAll();
          break;
        case '⌫':
          _calculatorService.deleteLast();
          break;
        case '=':
          _calculatorService.compute();
          break;
        case '±':
          _calculatorService.toggleSign();
          break;
        default:
          _calculatorService.handleInput(key);
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;
    final char = event.character;

    if (char == '*') {
      _handleKeyPress('×');
      return KeyEventResult.handled;
    }
    if (char == '+') {
      _handleKeyPress('+');
      return KeyEventResult.handled;
    }
    if (char == '-') {
      _handleKeyPress('-');
      return KeyEventResult.handled;
    }
    if (char == '/') {
      _handleKeyPress('÷');
      return KeyEventResult.handled;
    }
    if (char == '=') {
      _handleKeyPress('=');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _handleKeyPress('=');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace) {
      _handleKeyPress('⌫');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.delete ||
        key == LogicalKeyboardKey.keyC) {
      _handleKeyPress('AC');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.period ||
        key == LogicalKeyboardKey.numpadDecimal) {
      _handleKeyPress('.');
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.numpadAdd) {
      _handleKeyPress('+');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpadSubtract ||
        key == LogicalKeyboardKey.minus) {
      _handleKeyPress('-');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpadMultiply ||
        key == LogicalKeyboardKey.asterisk ||
        key == LogicalKeyboardKey.keyX) {
      _handleKeyPress('×');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpadDivide ||
        key == LogicalKeyboardKey.slash) {
      _handleKeyPress('÷');
      return KeyEventResult.handled;
    }

    bool isShift =
        HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftLeft,
        ) ||
        HardwareKeyboard.instance.logicalKeysPressed.contains(
          LogicalKeyboardKey.shiftRight,
        );

    if (!isShift) {
      if (key == LogicalKeyboardKey.digit0) {
        _handleKeyPress('0');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit1) {
        _handleKeyPress('1');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit2) {
        _handleKeyPress('2');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit3) {
        _handleKeyPress('3');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit4) {
        _handleKeyPress('4');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit5) {
        _handleKeyPress('5');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit6) {
        _handleKeyPress('6');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit7) {
        _handleKeyPress('7');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit8) {
        _handleKeyPress('8');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit9) {
        _handleKeyPress('9');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.equal) {
        _handleKeyPress('=');
        return KeyEventResult.handled;
      }
    }

    if (key == LogicalKeyboardKey.numpad0) {
      _handleKeyPress('0');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad1) {
      _handleKeyPress('1');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad2) {
      _handleKeyPress('2');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad3) {
      _handleKeyPress('3');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad4) {
      _handleKeyPress('4');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad5) {
      _handleKeyPress('5');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad6) {
      _handleKeyPress('6');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad7) {
      _handleKeyPress('7');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad8) {
      _handleKeyPress('8');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpad9) {
      _handleKeyPress('9');
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        widget.currentThemeMode == ThemeMode.dark ||
        (widget.currentThemeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[200],
      body: GestureDetector(
        onTap: () {
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: _handleKeyEvent,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 800),
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(
                  kIsWeb ||
                          Platform.isWindows ||
                          Platform.isMacOS ||
                          Platform.isLinux
                      ? 24
                      : 0,
                ),
                clipBehavior: Clip.antiAlias,
                child: Scaffold(
                  backgroundColor: colorScheme.surface,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ThemeSwitcher(
                          isDarkMode: isDark,
                          onChanged: widget.onThemeToggle,
                        ),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListenableBuilder(
                            listenable: _calculatorService as ChangeNotifier,
                            builder: (context, _) {
                              return CalculatorDisplay(
                                expression: _calculatorService.expression,
                                result: _calculatorService.currentResult,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CalculatorKeyboard(
                              buttons: _buildKeyboardButtons(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildKeyboardButtons(BuildContext context) {
    final keys = [
      'AC',
      '⌫',
      '±',
      '÷',
      '7',
      '8',
      '9',
      '×',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '0',
      '.',
      '=',
    ];

    final colorScheme = Theme.of(context).colorScheme;

    return keys.map((key) {
      Widget content;
      Color? bgColor;
      Color? txtColor;
      int flex = (key == '0') ? 2 : 1;

      if (key == '⌫') {
        content = const Icon(Icons.backspace_outlined);
      } else {
        content = Text(key);
      }

      if (['÷', '×', '-', '+', '='].contains(key)) {
        bgColor = colorScheme.primary;
        txtColor = colorScheme.onPrimary;
      } else if (['AC', '⌫', '±'].contains(key)) {
        bgColor = colorScheme.secondaryContainer;
        txtColor = colorScheme.onSecondaryContainer;
      }

      return CalculatorButton(
        onTap: () {
          _handleKeyPress(key);
          _focusNode.requestFocus();
        },
        backgroundColor: bgColor,
        textColor: txtColor,
        flex: flex,
        child: content,
      );
    }).toList();
  }
}
