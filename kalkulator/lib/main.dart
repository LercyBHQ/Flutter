import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const KalkulatorApp());
}

class KalkulatorApp extends StatelessWidget {
  const KalkulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const KalkulatorHome(),
    );
  }
}

class KalkulatorHome extends StatefulWidget {
  const KalkulatorHome({super.key});

  @override
  State<KalkulatorHome> createState() => _KalkulatorHomeState();
}

class _KalkulatorHomeState extends State<KalkulatorHome> {
  String _input = '';
  String _output = '';

  void _onButtonPressed(String label) {
    setState(() {
      if (label == 'C') {
        _input = '';
        _output = '';
      } else if (label == '=') {
        _calculate();
      } else {
        _input += label;
      }
    });
  }

  void _calculate() {
    if (_input.isEmpty) return;

    final expression = _input
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('%', '/100')
        .replaceAll('−', '-');

    try {
      final parser = Parser();
      final exp = parser.parse(expression);
      final result = exp.evaluate(EvaluationType.REAL, ContextModel());
      final text = result.toString();
      _output = text.endsWith('.0') ? text.replaceAll('.0', '') : text;
    } catch (e) {
      _output = 'Error';
    }
  }

  Widget _buildButton(String label,
      {Color? bgColor = const Color(0xFF1C1C1C), Color textColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            onPressed: () => _onButtonPressed(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 3,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(fontSize: 28, color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['C', '%', '÷', '×'],
      ['7', '8', '9', '-'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '='],
      ['0', '.', '', ''],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
        backgroundColor: Colors.black,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _input.isEmpty ? '0' : _input,
                  style: const TextStyle(fontSize: 36, color: Colors.white70),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                _output,
                style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: buttons.map((row) {
                      return Expanded(
                        child: Row(
                          children: row.map((label) {
                            if (label.isEmpty) return const Spacer();
                            Color? bg;
                            Color textColor = Colors.white;

                            if (label == 'C') bg = Colors.redAccent;
                            else if (label == '=') bg = Colors.teal;
                            else if ('÷×-%+'.contains(label)) {
                              bg = Colors.deepOrangeAccent;
                              textColor = Colors.white;
                            }

                            return _buildButton(label, bgColor: bg, textColor: textColor);
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
