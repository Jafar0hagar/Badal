class OrderItem {
  final String id;
  final String productName;
  final String price;
  final String unit;
  final String customerName;
  final String customerPhone;
  final String notes;
  final String status;
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
    required this.createdAt,
  });

  factory OrderItem.fromFirestore(Map<String, dynamic> json, String docId) {
    return OrderItem(
      id: docId,
      productName: json['productName'] ?? '',
      price: json['price']?.toString() ?? '',
      unit: json['unit'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      notes: json['notes'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'productName': productName,
      'price': price,
      'unit': unit,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
