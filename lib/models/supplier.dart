class Supplier {
  final String id;
  final String name;
  final String phone;
  final String? pin;
  final String warehouseAddress;
  final List<String> assignedProducts;
  final String status;
  final int createdAt;

  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    this.pin,
    required this.warehouseAddress,
    required this.assignedProducts,
    required this.status,
    required this.createdAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json, String docId) {
    final rawAssigned = json['assignedProducts'];
    List<String> productsList = [];
    if (rawAssigned is List) {
      productsList = rawAssigned.map((e) => e.toString()).toList();
    }

    return Supplier(
      id: docId,
      name: json['name'] as String? ?? 'مورّد معتمد',
      phone: json['phone'] as String? ?? '',
      pin: json['pin']?.toString(),
      warehouseAddress: json['warehouseAddress'] as String? ?? 'المستودع الرئيسي',
      assignedProducts: productsList,
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] is int
          ? json['createdAt'] as int
          : DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      if (pin != null) 'pin': pin,
      'warehouseAddress': warehouseAddress,
      'assignedProducts': assignedProducts,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
