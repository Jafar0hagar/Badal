class Currency {
  final String id;
  final String name;
  final String code;
  final String symbol;
  final double buyPrice;
  final double sellPrice;
  final String change; // 'up', 'down', 'stable'
  final String country;
  final String contactPhone;
  final int updatedAt;

  Currency({
    required this.id,
    required this.name,
    required this.code,
    required this.symbol,
    required this.buyPrice,
    required this.sellPrice,
    required this.change,
    required this.country,
    required this.contactPhone,
    required this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json, String docId) {
    return Currency(
      id: docId,
      name: json['name'] as String? ?? 'عملة',
      code: json['code'] as String? ?? docId.toUpperCase(),
      symbol: json['symbol'] as String? ?? '',
      buyPrice: (json['buyPrice'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sellPrice'] as num?)?.toDouble() ?? 0.0,
      change: json['change'] as String? ?? 'stable',
      country: json['country'] as String? ?? '',
      contactPhone: json['contactPhone'] as String? ?? '+249912345678',
      updatedAt: json['updatedAt'] is int
          ? json['updatedAt'] as int
          : DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'symbol': symbol,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'change': change,
      'country': country,
      'contactPhone': contactPhone,
      'updatedAt': updatedAt,
    };
  }

  Currency copyWith({
    String? id,
    String? name,
    String? code,
    String? symbol,
    double? buyPrice,
    double? sellPrice,
    String? change,
    String? country,
    String? contactPhone,
    int? updatedAt,
  }) {
    return Currency(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      change: change ?? this.change,
      country: country ?? this.country,
      contactPhone: contactPhone ?? this.contactPhone,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
