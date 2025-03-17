import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/exchange_rate_chart.dart';

class TrendsScreen extends StatelessWidget {
  final String fromCurrency;
  final String toCurrency;
  final double exchangeRate;
  final List<FlSpot> historicalData;

  const TrendsScreen({
    Key? key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.exchangeRate,
    required this.historicalData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Exchange Rate Trend: $fromCurrency to $toCurrency",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Current Rate: 1 $fromCurrency = ${exchangeRate.toStringAsFixed(4)} $toCurrency",
                    style: const TextStyle(color: Colors.blue),
                  ),
                  const Text(
                    "(Simulated data for demonstration)",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ExchangeRateChart(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              exchangeRate: exchangeRate,
              historicalData: historicalData,
            ),
          ),
        ],
      ),
    );
  }
}