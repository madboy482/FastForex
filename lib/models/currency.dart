class Currency {
  final String code;
  final double rate;
  final bool isFavorite;

  Currency({
    required this.code,
    required this.rate,
    this.isFavorite = false,
  });

  Currency copyWith({
    String? code,
    double? rate,
    bool? isFavorite,
  }) {
    return Currency(
      code: code ?? this.code,
      rate: rate ?? this.rate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Currency{code: $code, rate: $rate, isFavorite: $isFavorite}';
  }
}