import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ""; // Expressão digitada
  String output = "0"; // Resultado

  void onButtonPressed(String value) {
    setState(() {
      if (value == "AC") {
        input = "";
        output = "0";
      } else if (value == "⌫") {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == "=") {
        calcularResultado();
      } else {
        input += value;
      }
    });
  }

  void calcularResultado() {
    try {
      String expression = input.replaceAll("×", "*").replaceAll("÷", "/");

      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      output = eval.toString(); // Exibe resultado no output
    } catch (e) {
      output = "Erro";
    }

    setState(() {});
  }

  Widget buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.purple.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade700,
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  Text(
                    output,
                    style: const TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children:
                [
                  ["AC", "⌫", "÷", "×"],
                  ["7", "8", "9", "-"],
                  ["4", "5", "6", "+"],
                  ["1", "2", "3", "="],
                  ["0", ".", "^"],
                ].map((row) {
                  return Row(
                    children: row.map((text) => buildButton(text)).toList(),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
