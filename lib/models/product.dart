class Product {
  final String id;
  final String name;
  final double price;
  final String unit;
  final String category; // 'sugar', 'flour', 'oil', 'other'
  final bool inStock;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.inStock,
    this.image = '',
    this.description = '',
  });

  factory Product.fromJson(Map<String, dynamic> json, String docId) {
    return Product(
      id: docId,
      name: json['name'] as String? ?? 'سلعة',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? 'وحدة',
      category: json['category'] as String? ?? 'other',
      inStock: json['inStock'] as bool? ?? true,
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'unit': unit,
      'category': category,
      'inStock': inStock,
      'image': image,
      'description': description,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? unit,
    String? category,
    bool? inStock,
    String? image,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      inStock: inStock ?? this.inStock,
      image: image ?? this.image,
      description: description ?? this.description,
    );
  }
}
