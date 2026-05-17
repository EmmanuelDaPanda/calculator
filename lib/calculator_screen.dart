import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // result variables
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // result
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: [Btn.n0].contains(value)
                          ? screenSize.width / 2
                          : screenSize.width / 4,
                      height: screenSize.width / 4.1,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: [Btn.calculate].contains(value)
            ? Colors.green
            : Colors.grey.shade900,
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: getBtnColor(value),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // on button tap
  void onBtnTap(value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    // if (value == Btn.per) {
    //   convertToPercentage();
    //   return;
    // }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  // append value
  void appendValue(String value) {
    // appends operand value
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && (number2.isNotEmpty || operand == Btn.per)) {
        calculate();
      }
      operand = value;
    }
    // appends number1
    else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        number1 = "0.";
      } else if (number1.contains(Btn.dot) && value != Btn.dot) {
        final split = number1.split(Btn.dot);
        if (split.length > 1 && split[1].length >= 3) return;
        number1 += value;
      } else if (value != Btn.dot && number1 == Btn.n0) {
        number1 = value;
      } else {
        number1 += value;
      }
    }
    // appends number2
    else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        number2 = "0.";
        number2 = "0.";
      } else if (number2.contains(Btn.dot) && value != Btn.dot) {
        final split = number2.split(Btn.dot);
        if (split.length > 1 && split[1].length >= 3) return;
        number2 += value;
      } else if (value != Btn.dot && number2 == Btn.n0) {
        number2 = value;
      } else {
        number2 += value;
      }
    }

    setState(() {});
  }

  // delete
  void delete() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }

  // clear all
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // convert to percentage
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  // calculate function
  void calculate() {
    // if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;
    if (number1.isEmpty || operand.isEmpty) return;

    // handle case where only number1 and % are provided (e.g. 10%)
    if (number2.isEmpty && operand == Btn.per) {
      final double num1 = double.parse(number1);
      final result = num1 / 100;
      setState(() {
        // number1 = "$result";
        // if (number1.endsWith(".0")) {
        //   number1 = number1.substring(0, number1.length - 2);
        // }
        number1 = formatResult(result);
        operand = "";
        number2 = "";
      });
      return;
    }

    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      case Btn.per:
        result = (num1 / 100) * num2;
        break;
      default:
    }

    setState(() {
      // number1 = "$result";

      // if (number1.endsWith(".0")) {
      //   number1 = number1.substring(0, number1.length - 2);
      // }
      number1 = formatResult(result);

      operand = "";
      number2 = "";
    });
  }

  // Helper to format result: limit to 3 decimals and remove trailing zeros
  String formatResult(double result) {
    String formatted = result.toStringAsFixed(3);
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(
        RegExp(r'0*$'),
        '',
      ); // remove trailing zeros
      formatted = formatted.replaceAll(
        RegExp(r'\.$'),
        '',
      ); // remove trailing dot
    }
    return formatted;
  }

  // get button color
  Color getBtnColor(value) {
    if (value == Btn.clr || value == Btn.del) {
      return Colors.redAccent.shade700;
    }
    if (value == Btn.per ||
        value == Btn.multiply ||
        value == Btn.add ||
        value == Btn.subtract ||
        value == Btn.divide) {
      return Colors.orange.shade700;
    }

    return Colors.white;
  }
}
