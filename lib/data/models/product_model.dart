class Product {
  final String id;
  final String name;
  final double price;
  final String unit;
  final String category;
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
    required this.image,
    this.description = '',
  });

  factory Product.fromFirestore(Map<String, dynamic> json, String docId) {
    return Product(
      id: docId,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? 'جوال ٥٠ كجم',
      category: json['category'] ?? 'foodstuffs',
      inStock: json['inStock'] ?? true,
      image: json['image'] ?? json['imageUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'unit': unit,
      'category': category,
      'inStock': inStock,
      'image': image,
      'description': description,
    };
  }
}
