class Currency {
  final String id;
  final String name;
  final double buyPrice;
  final double sellPrice;
  final String change;
  final int updatedAt;
  final String flag;
  final String symbol;

  Currency({
    required this.id,
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.change,
    required this.updatedAt,
    this.flag = '🇸🇩',
    this.symbol = 'ج.س',
  });

  factory Currency.fromFirestore(Map<String, dynamic> json, String docId) {
    return Currency(
      id: docId,
      name: json['name'] ?? '',
      buyPrice: (json['buyPrice'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sellPrice'] as num?)?.toDouble() ?? 0.0,
      change: json['change'] ?? 'stable',
      updatedAt: json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      flag: _getFlagForCurrency(docId),
      symbol: _getSymbolForCurrency(docId),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'change': change,
      'updatedAt': updatedAt,
    };
  }

  static String _getFlagForCurrency(String id) {
    switch (id.toLowerCase()) {
      case 'usd': return '🇺🇸';
      case 'xaf': return '🇹🇩';
      case 'sar': return '🇸🇦';
      case 'aed': return '🇦🇪';
      case 'egp': return '🇪🇬';
      case 'eur': return '🇪🇺';
      case 'ngn': return '🇳🇬';
      default: return '💱';
    }
  }

  static String _getSymbolForCurrency(String id) {
    switch (id.toLowerCase()) {
      case 'usd': return '\$';
      case 'xaf': return 'FCFA';
      case 'sar': return 'ر.س';
      case 'aed': return 'د.إ';
      case 'egp': return 'ج.م';
      case 'eur': return '€';
      case 'ngn': return '₦';
      default: return 'ج.س';
    }
  }
}
