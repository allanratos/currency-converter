import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {

  final TextEditingController controller = TextEditingController();
  String result = "";

  Future<void> convert() async {

    const apiKey = "c4bef85f";
    final url = Uri.parse("https://api.hgbrasil.com/finance?key=$apiKey");

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    double usd = data["results"]["currencies"]["USD"]["buy"];
    double brl = double.parse(controller.text);

    double converted = brl / usd;

    setState(() {
      result = "${converted.toStringAsFixed(2)} USD";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Valor em BRL",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: convert,
              child: const Text("Converter"),
            ),

            const SizedBox(height: 20),

            Text(
              result,
              style: const TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}