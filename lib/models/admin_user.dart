class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin_full' | 'supervisor'
  final String? pin;
  final String? phone;
  final String? whatsappPhone;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.pin,
    this.phone,
    this.whatsappPhone,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json, String docId) {
    return AdminUser(
      id: docId,
      name: json['name'] as String? ?? 'مشرف النظام',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'supervisor',
      pin: json['pin']?.toString(),
      phone: json['phone']?.toString(),
      whatsappPhone: json['whatsappPhone']?.toString() ?? json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      if (pin != null) 'pin': pin,
      if (phone != null) 'phone': phone,
      if (whatsappPhone != null) 'whatsappPhone': whatsappPhone,
    };
  }
}
