import 'package:flutter/material.dart';

class CalculatorKeyboard extends StatelessWidget {
  final List<Widget> buttons;

  const CalculatorKeyboard({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> rows = [];

    int i = 0;
    while (i < buttons.length) {
      bool isLastRow = (buttons.length - i) == 3;
      int chunk = isLastRow ? 3 : 4;

      rows.add(buttons.sublist(i, i + chunk));
      i += chunk;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: rows.map((rowButtons) {
        return Expanded(child: Row(children: rowButtons));
      }).toList(),
    );
  }
}
