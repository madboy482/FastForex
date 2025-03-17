import 'package:flutter/material.dart';

class ConversionResultCard extends StatelessWidget {
  final String result;
  final String fromCurrency;
  final String toCurrency;
  final double exchangeRate;

  const ConversionResultCard({
    Key? key,
    required this.result,
    required this.fromCurrency,
    required this.toCurrency,
    required this.exchangeRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Text(
            "Result",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            result.isEmpty ? "Enter an amount and press Convert" : result,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: result.isEmpty ? Colors.grey : Colors.blueAccent,
            ),
            textAlign: TextAlign.center,
          ),
          if (exchangeRate > 0) ...[
            const SizedBox(height: 8.0),
            Text(
              "1 $fromCurrency = ${exchangeRate.toStringAsFixed(4)} $toCurrency",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}