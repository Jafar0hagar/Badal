import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../models/order.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'name': 'الكل'},
    {'id': 'sugar', 'name': 'السكر'},
    {'id': 'flour', 'name': 'الدقيق'},
    {'id': 'oil', 'name': 'الزيوت'},
    {'id': 'other', 'name': 'أرز وبقوليات'},
  ];

  void _showOrderDialog(BuildContext context, Product p, AppState appState) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.goldBorder),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'طلب شراء سلعة تموينية',
              style: TextStyle(color: AppTheme.gold, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${p.name} (${p.unit})',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('السعر الحالي:', style: TextStyle(color: AppTheme.textDim, fontSize: 11)),
              Text(
                '${p.price.toStringAsFixed(0)} ج.س / ${p.unit}',
                style: const TextStyle(color: AppTheme.gold, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'الاسم الكريم',
                  hintText: 'مثال: محمد أحمد',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف / الواتساب',
                  hintText: 'مثال: 0912345678',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesCtrl,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'الكمية ومكان التوصيل',
                  hintText: 'مثال: 5 جوالات، مخازن سوق أمدرمان',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: AppTheme.textDim)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emerald),
            onPressed: () {
              final cName = nameCtrl.text.trim();
              final cPhone = phoneCtrl.text.trim();
              if (cName.isEmpty || cPhone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء إدخال الاسم ورقم الهاتف لإتمام الطلب'),
                    backgroundColor: AppTheme.rose,
                  ),
                );
                return;
              }

              final order = OrderItem(
                id: 'order-${DateTime.now().millisecondsSinceEpoch}',
                productName: p.name,
                price: p.price.toStringAsFixed(0),
                unit: p.unit,
                customerName: cName,
                customerPhone: cPhone,
                notes: notesCtrl.text.trim(),
                status: 'pending',
                timestamp: 'الآن',
                createdAt: DateTime.now().millisecondsSinceEpoch,
              );

              appState.addOrder(order);
              Navigator.pop(ctx);

              // Direct WhatsApp dispatch for instant confirmation
              appState.openWhatsApp(
                phone: appState.adminPhone,
                message: 'السلام عليكم ورحمة الله،\nأود تأكيد طلب شراء سلعة من تطبيق بَدَلْ:\n- السلعة: ${p.name}\n- الكمية والوحدة: ${p.unit}\n- السعر: ${p.price.toStringAsFixed(0)} ج.س\n- الاسم: $cName\n- الهاتف: $cPhone\n- الملاحظات وموقع التسليم: ${notesCtrl.text.trim()}',
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ تم حفظ الطلب وفتح محادثة واتساب لإتمام التأكيد الفوري'),
                  backgroundColor: AppTheme.emerald,
                ),
              );
            },
            child: const Text('تأكيد وإرسال عبر واتساب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final products = appState.products;

    final filtered = _selectedCategory == 'all'
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('السلع والمواد الغذائية الاستراتيجية'),
      ),
      body: Column(
        children: [
          // Categories Filter Bar
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final isSelected = cat['id'] == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['id']!),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.gold : AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppTheme.gold : AppTheme.goldBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat['name']!,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF0C0A09) : AppTheme.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد سلع متاحة في هذا التصنيف حالياً',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final p = filtered[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.goldBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: p.inStock
                                        ? AppTheme.emerald.withOpacity(0.15)
                                        : AppTheme.rose.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    p.inStock ? 'متوفر بالمخزون' : 'غير متوفر',
                                    style: TextStyle(
                                      color: p.inStock ? AppTheme.emeraldLight : AppTheme.rose,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (p.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                p.description,
                                style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'الوحدة: ${p.unit}',
                                      style: const TextStyle(color: AppTheme.textDim, fontSize: 10),
                                    ),
                                    Text(
                                      '${p.price.toStringAsFixed(0)} ج.س',
                                      style: const TextStyle(
                                        color: AppTheme.gold,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: p.inStock ? AppTheme.gold : AppTheme.surfaceLighter,
                                    foregroundColor: const Color(0xFF0C0A09),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: p.inStock
                                      ? () => _showOrderDialog(context, p, appState)
                                      : null,
                                  icon: const Icon(Icons.shopping_cart_checkout, size: 15),
                                  label: const Text(
                                    'طلب شراء مباشر',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
