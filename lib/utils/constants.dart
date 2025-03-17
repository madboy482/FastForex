class Constants {
  // API key for OpenExchangeRates
  static const String API_KEY = "your_api_key";
  
  // Default currencies
  static const List<String> DEFAULT_CURRENCIES = ["USD", "EUR", "GBP", "JPY", "INR"];
  
  // SharedPreferences keys
  static const String PREFS_DARK_THEME = 'isDarkTheme';
  static const String PREFS_HISTORY = 'conversionHistory';
  static const String PREFS_FAVORITES = 'favoriteCurrencies';
  
  // Max history items
  static const int MAX_HISTORY_ITEMS = 10;
}