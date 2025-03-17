import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import '../models/currency.dart';

class CurrencyApiService {
  final String apiKey = Constants.API_KEY;
  Map<String, double> allRates = {};
  List<String> currencies = [];
  String errorMessage = "";
  bool isLoading = false;

  Future<Map<String, double>> fetchAllRates() async {
    isLoading = true;
    errorMessage = "";

    final url = "https://openexchangerates.org/api/latest.json?app_id=$apiKey";
    print("Fetching from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Response received successfully");

        if (data.containsKey("rates")) {
          final Map<String, dynamic> rawRates = data["rates"];
          allRates.clear();

          // Properly handle both int and double values
          rawRates.forEach((currency, value) {
            if (value is int) {
              allRates[currency] = value.toDouble();
            } else if (value is double) {
              allRates[currency] = value;
            } else {
              // Try to parse the value to a double if it's another type
              try {
                allRates[currency] = double.parse(value.toString());
              } catch (e) {
                print("Could not convert rate for $currency: $value");
              }
            }
          });

          currencies = allRates.keys.toList();
          isLoading = false;
          return allRates;
        } else {
          print("Response is missing 'rates' key. Available keys: ${data.keys.toList()}");
          errorMessage = "API response format not as expected";
          isLoading = false;
          return {};
        }
      } else {
        print("API error: ${response.statusCode}");
        print("Response: ${response.body}");
        errorMessage = "Failed to load rates: HTTP ${response.statusCode}";
        isLoading = false;
        return {};
      }
    } catch (e) {
      print("Exception during API call: $e");
      errorMessage = "Network error: $e";
      isLoading = false;
      return {};
    }
  }

  double calculateExchangeRate(String fromCurrency, String toCurrency) {
    if (allRates.isEmpty) {
      return 0.0;
    }

    if (fromCurrency == "USD") {
      // Direct conversion from USD (base currency for this API)
      return allRates[toCurrency] ?? 0.0;
    } else if (toCurrency == "USD") {
      // Inverse conversion to USD
      double fromRate = allRates[fromCurrency] ?? 1.0;
      return 1.0 / fromRate;
    } else {
      // Cross conversion between non-USD currencies
      double fromRate = allRates[fromCurrency] ?? 1.0;
      double toRate = allRates[toCurrency] ?? 1.0;
      return toRate / fromRate;
    }
  }

  List<Currency> getAllCurrencies() {
    return currencies
        .map((code) => Currency(
              code: code,
              rate: allRates[code] ?? 0.0,
            ))
        .toList();
  }

  String getErrorMessage() {
    return errorMessage;
  }

  bool getIsLoading() {
    return isLoading;
  }
}