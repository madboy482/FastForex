import 'package:flutter/material.dart';
import 'convert_screen.dart';
import 'history_screen.dart';
import 'trends_screen.dart';
import 'favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../services/currency_api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkTheme;

  const HomeScreen({Key? key, required this.toggleTheme, required this.isDarkTheme}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isLoading = true;
  String errorMessage = "";
  List<String> conversionHistory = [];
  List<String> favoriteCurrencies = ["USD", "EUR", "GBP", "JPY", "INR"];
  String? selectedCurrency;
  final CurrencyApiService _apiService = CurrencyApiService();
  Map<String, double> allRates = {};
  List<String> currencies = ["USD", "INR", "EUR", "GBP", "JPY"]; // Default currencies
  String fromCurrency = "USD";
  String toCurrency = "INR";
  double exchangeRate = 0.0;

  @override
  void initState() {
    super.initState();
    loadPreferences();
    fetchAllRates();
  }

  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        conversionHistory = prefs.getStringList(Constants.PREFS_HISTORY) ?? [];
        favoriteCurrencies = prefs.getStringList(Constants.PREFS_FAVORITES) ?? Constants.DEFAULT_CURRENCIES;
      });
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  Future<void> savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(Constants.PREFS_HISTORY, conversionHistory);
      await prefs.setStringList(Constants.PREFS_FAVORITES, favoriteCurrencies);
    } catch (e) {
      print("Error saving preferences: $e");
    }
  }

  Future<void> fetchAllRates() async {
    setState(() {
      isLoading = true;
    });

    allRates = await _apiService.fetchAllRates();
    
    setState(() {
      currencies = allRates.keys.toList();
      calculateExchangeRate();
      isLoading = false;
      errorMessage = _apiService.getErrorMessage();
    });
  }

  void calculateExchangeRate() {
    exchangeRate = _apiService.calculateExchangeRate(fromCurrency, toCurrency);
  }

  void updateCurrencyFromTo(String from, String to) {
    setState(() {
      fromCurrency = from;
      toCurrency = to;
      calculateExchangeRate();
    });
  }

  void addToHistory(String result) {
    setState(() {
      if (!conversionHistory.contains(result)) {
        conversionHistory.insert(0, result);
        if (conversionHistory.length > Constants.MAX_HISTORY_ITEMS) {
          conversionHistory.removeRange(Constants.MAX_HISTORY_ITEMS, conversionHistory.length);
        }
        savePreferences();
      }
    });
  }

  void toggleFavorite(String currency) {
    setState(() {
      if (favoriteCurrencies.contains(currency)) {
        favoriteCurrencies.remove(currency);
      } else {
        favoriteCurrencies.add(currency);
      }
      
      selectedCurrency = null;
      savePreferences();
    });
  }

  // Generate simulated historical data for trends
  List<FlSpot> getHistoricalData() {
    List<FlSpot> spots = [];
    double baseRate = exchangeRate;

    // Generate 14 days of simulated data with realistic fluctuations
    for (int i = 0; i < 14; i++) {
      // Create a small random fluctuation based on the day
      double randomFactor = 0.95 + (0.1 * (i % 3 == 0 ? 1 : -0.5) * (i / 14));
      double simulatedRate = baseRate * randomFactor;
      spots.add(FlSpot((13 - i).toDouble(), simulatedRate));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("FastForex",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(widget.isDarkTheme ? Icons.dark_mode : Icons.light_mode),
              onPressed: widget.toggleTheme,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.currency_exchange), text: "Convert"),
              Tab(icon: Icon(Icons.history), text: "History"),
              Tab(icon: Icon(Icons.trending_up), text: "Trends"),
              Tab(icon: Icon(Icons.star), text: "Favorites"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // Convert Tab
                  ConvertScreen(
                    fromCurrency: fromCurrency,
                    toCurrency: toCurrency,
                    currencies: currencies,
                    favoriteCurrencies: favoriteCurrencies,
                    exchangeRate: exchangeRate,
                    allRates: allRates,
                    errorMessage: errorMessage,
                    updateCurrencyFromTo: updateCurrencyFromTo, 
                    toggleFavorite: toggleFavorite,
                    addToHistory: addToHistory,
                    fetchExchangeRate: calculateExchangeRate,
                  ),
                  
                  // History Tab
                  HistoryScreen(
                    conversionHistory: conversionHistory,
                    onDeleteHistory: (int index) {
                      setState(() {
                        conversionHistory.removeAt(index);
                        savePreferences();
                      });
                    },
                  ),

                  // Trends Tab
                  TrendsScreen(
                    fromCurrency: fromCurrency,
                    toCurrency: toCurrency,
                    exchangeRate: exchangeRate,
                    historicalData: getHistoricalData(),
                  ),

                  // Favorites Tab
                  FavoritesScreen(
                    favoriteCurrencies: favoriteCurrencies,
                    allRates: allRates,
                    currencies: currencies,
                    selectedCurrency: selectedCurrency,
                    onToggleFavorite: toggleFavorite,
                    onCurrencySelected: (currency) {
                      setState(() {
                        selectedCurrency = currency;
                      });
                    },
                    onCurrencyTap: (currency) {
                      setState(() {
                        toCurrency = currency;
                        DefaultTabController.of(context).animateTo(0);
                        calculateExchangeRate();
                      });
                    },
                  ),
                ],
              ),
      ),
    );
  }
}