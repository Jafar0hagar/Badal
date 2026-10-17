class OrderItem {
  final String id;
  final String productName;
  final String price;
  final String unit;
  final String customerName;
  final String customerPhone;
  final String notes;
  final String status; // 'pending' | 'completed' | 'cancelled' | 'processing'
  final String timestamp;
  final int createdAt;

  OrderItem({
    required this.id,
    required this.productName,
    required this.price,
    required this.unit,
    required this.customerName,
    required this.customerPhone,
    required this.notes,
    required this.status,
    required this.timestamp,
    required this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json, String docId) {
    return OrderItem(
      id: docId,
      productName: json['productName'] as String? ?? 'سلعة تموينية',
      price: json['price']?.toString() ?? '0',
      unit: json['unit'] as String? ?? 'وحدة',
      customerName: json['customerName'] as String? ?? 'زبون',
      customerPhone: json['customerPhone'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      timestamp: json['timestamp'] as String? ?? 'الآن',
      createdAt: json['createdAt'] is int
          ? json['createdAt'] as int
          : DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'price': price,
      'unit': unit,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
      'status': status,
      'timestamp': timestamp,
      'createdAt': createdAt,
    };
  }

  OrderItem copyWith({
    String? id,
    String? productName,
    String? price,
    String? unit,
    String? customerName,
    String? customerPhone,
    String? notes,
    String? status,
    String? timestamp,
    int? createdAt,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
