import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {
  final String fromCurrency;
  final String toCurrency;
  final List<String> currencies;
  final List<String> favoriteCurrencies;
  final double exchangeRate;
  final Map<String, double> allRates;
  final String errorMessage;
  final Function(String, String) updateCurrencyFromTo;
  final Function(String) toggleFavorite;
  final Function(String) addToHistory;
  final Function fetchExchangeRate;

  const ConvertScreen({
    Key? key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.currencies,
    required this.favoriteCurrencies,
    required this.exchangeRate,
    required this.allRates,
    required this.errorMessage,
    required this.updateCurrencyFromTo,
    required this.toggleFavorite,
    required this.addToHistory,
    required this.fetchExchangeRate,
  }) : super(key: key);

  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  final TextEditingController _amountController = TextEditingController();
  String fromCurrency = "USD";
  String toCurrency = "INR";
  String result = "";

  @override
  void initState() {
    super.initState();
    fromCurrency = widget.fromCurrency;
    toCurrency = widget.toCurrency;
  }

  @override
  void didUpdateWidget(ConvertScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fromCurrency != widget.fromCurrency || 
        oldWidget.toCurrency != widget.toCurrency) {
      fromCurrency = widget.fromCurrency;
      toCurrency = widget.toCurrency;
    }
  }

  void swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      widget.updateCurrencyFromTo(fromCurrency, toCurrency);
    });
  }

  void convertCurrency() {
    if (_amountController.text.isEmpty) return;

    try {
      double amount = double.parse(_amountController.text);
      double convertedAmount = amount * widget.exchangeRate;

      String newResult = "$amount $fromCurrency = ${convertedAmount.toStringAsFixed(2)} $toCurrency";

      setState(() {
        result = newResult;
        widget.addToHistory(newResult);
      });
    } catch (e) {
      setState(() {
        result = "Please enter a valid number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Show error message if there is one
          if (widget.errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                widget.errorMessage,
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),

          // Amount field with improved styling
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter Amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.attach_money),
            ),
          ),

          const SizedBox(height: 24.0),

          // Currency selection row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: fromCurrency,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        fromCurrency = newValue;
                        widget.updateCurrencyFromTo(fromCurrency, toCurrency);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "From",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: widget.currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currency),
                          Icon(
                            widget.favoriteCurrencies.contains(currency) ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Swap button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: swapCurrencies,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: DropdownButtonFormField<String>(
                  value: toCurrency,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        toCurrency = newValue;
                        widget.updateCurrencyFromTo(fromCurrency, toCurrency);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "To",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: widget.currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currency),
                          Icon(
                            widget.favoriteCurrencies.contains(currency) ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24.0),

          // Convert button
          ElevatedButton(
            onPressed: convertCurrency,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              "Convert",
              style: TextStyle(fontSize: 16.0),
            ),
          ),

          const SizedBox(height: 24.0),

          // Result display
          Container(
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
                if (widget.exchangeRate > 0) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    "1 $fromCurrency = ${widget.exchangeRate.toStringAsFixed(4)} $toCurrency",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24.0),

          // Exchange rate info section
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Popular Exchange Rates",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text("1 USD = ${widget.allRates["EUR"]?.toStringAsFixed(4) ?? 'N/A'} EUR"),
                Text("1 USD = ${widget.allRates["GBP"]?.toStringAsFixed(4) ?? 'N/A'} GBP"),
                Text("1 USD = ${widget.allRates["JPY"]?.toStringAsFixed(4) ?? 'N/A'} JPY"),
                Text("1 USD = ${widget.allRates["INR"]?.toStringAsFixed(4) ?? 'N/A'} INR"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}