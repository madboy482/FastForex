import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteCurrencies;
  final Map<String, double> allRates;
  final List<String> currencies;
  final String? selectedCurrency;
  final Function(String) onToggleFavorite;
  final Function(String?) onCurrencySelected;
  final Function(String) onCurrencyTap;

  const FavoritesScreen({
    Key? key,
    required this.favoriteCurrencies,
    required this.allRates,
    required this.currencies,
    required this.selectedCurrency,
    required this.onToggleFavorite,
    required this.onCurrencySelected,
    required this.onCurrencyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favorite Currencies",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: favoriteCurrencies.isEmpty
                ? const Center(child: Text("No favorite currencies yet"))
                : ListView.builder(
                    itemCount: favoriteCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = favoriteCurrencies[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: Text(currency),
                          subtitle: Text(
                            "1 USD = ${allRates[currency]?.toStringAsFixed(4) ?? 'N/A'} $currency",
                            style: const TextStyle(color: Colors.blue),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => onToggleFavorite(currency),
                          ),
                          onTap: () => onCurrencyTap(currency),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Add more currencies to favorites:",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedCurrency,
              hint: const Text("Select a currency"),
              onChanged: (newValue) {
                if (newValue != null && !favoriteCurrencies.contains(newValue)) {
                  onToggleFavorite(newValue);
                }
                onCurrencySelected(newValue);
              },
              items: currencies
                  .where((c) => !favoriteCurrencies.contains(c))
                  .map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}