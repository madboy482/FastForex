class ConversionHistoryItem {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double convertedAmount;
  final DateTime timestamp;

  ConversionHistoryItem({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();

  String get formattedResult {
    return "$amount $fromCurrency = ${convertedAmount.toStringAsFixed(2)} $toCurrency";
  }

  Map<String, dynamic> toJson() {
    return {
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ConversionHistoryItem.fromJson(Map<String, dynamic> json) {
    return ConversionHistoryItem(
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      amount: json['amount'],
      convertedAmount: json['convertedAmount'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  @override
  String toString() {
    return formattedResult;
  }
}