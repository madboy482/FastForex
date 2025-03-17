import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String value;
  final List<String> currencies;
  final List<String> favoriteCurrencies;
  final Function(String?) onChanged;
  final String labelText;

  const CurrencyDropdown({
    Key? key,
    required this.value,
    required this.currencies,
    required this.favoriteCurrencies,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      items: currencies.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(currency),
              Icon(
                favoriteCurrencies.contains(currency) ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}