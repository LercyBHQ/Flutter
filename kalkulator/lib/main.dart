import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const KalkulatorApp());
}

class KalkulatorApp extends StatelessWidget {
  const KalkulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Angka',
      theme: ThemeData.dark(),
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
  final TextEditingController _controller = TextEditingController();
  String _hasil = '';

  void _hitungAngka() {
    final expr = _controller.text
      .replaceAll('×', '*')
      .replaceAll('÷', '/');
    try {
      Parser p = Parser();
      Expression exp = p.parse(expr);
      double value = exp.evaluate(EvaluationType.REAL, ContextModel());
      setState(() {
        // Format: hilangkan .0 kalau bulat
        _hasil = value.toString().endsWith('.0')
          ? value.toInt().toString()
          : value.toString();
      });
    } catch (e) {
      setState(() {
        _hasil = 'Masukan Angka';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Angka')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Masukkan Angka',
                hintText: '',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9\+\-\×\÷\*\/\.\(\)]'),
                ),
              ],
              onSubmitted: (_) => _hitungAngka(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hitungAngka,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Hitung', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _hasil,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
