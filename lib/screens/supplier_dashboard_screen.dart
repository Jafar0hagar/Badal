import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../models/order.dart';

class SupplierDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> supplierData;

  const SupplierDashboardScreen({super.key, required this.supplierData});

  @override
  State<SupplierDashboardScreen> createState() => _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState extends State<SupplierDashboardScreen> {
  int _activeTab = 0; // 0: المخزون والسلع, 1: شحنات وطلبات التوريد

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final supplierName = widget.supplierData['name'] ?? 'مورّد معتمد';
    final supplierId = widget.supplierData['id'] ?? 'SUP-8801';
    final warehouse = widget.supplierData['warehouseAddress'] ?? 'المستودع الرئيسي';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0A09),
        appBar: AppBar(
          backgroundColor: const Color(0xFF161311),
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.emerald.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.emerald.withOpacity(0.3)),
                ),
                child: const Icon(Icons.local_shipping_outlined, color: AppTheme.emerald, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplierName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'معرّف المورّد: $supplierId • $warehouse',
                      style: const TextStyle(fontSize: 10, color: AppTheme.textDim),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.rose, size: 20),
              tooltip: 'تسجيل الخروج',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Top Navigation Tabs
            Container(
              color: const Color(0xFF14110F),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      index: 0,
                      label: 'مخزون السلع الموكلة',
                      icon: Icons.inventory_2_outlined,
                      badgeCount: appState.products.length,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTabButton(
                      index: 1,
                      label: 'طلبات التجهيز والشحن',
                      icon: Icons.receipt_long_outlined,
                      badgeCount: appState.orders.where((o) => o.status == 'pending').length,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _activeTab == 0
                  ? _buildInventoryList(appState)
                  : _buildOrdersList(appState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String label,
    required IconData icon,
    int? badgeCount,
  }) {
    final isActive = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.emerald : const Color(0xFF1F1B18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppTheme.emerald : const Color(0xFF332D29),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.black : Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.white70,
              ),
            ),
            if (badgeCount != null && badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black26 : AppTheme.emerald.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.black : AppTheme.emerald,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryList(AppState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.products.length,
      itemBuilder: (ctx, i) {
        final product = state.products[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF181512),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2B2521)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF221E1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF38312B)),
                ),
                child: const Center(
                  child: Icon(Icons.shopping_bag_outlined, color: AppTheme.emerald, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.price.toStringAsFixed(0)} ج.س • ${product.unit}',
                      style: const TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: product.inStock,
                    activeColor: AppTheme.emerald,
                    onChanged: (val) {
                      state.updateProduct(product.copyWith(inStock: val));
                    },
                  ),
                  Text(
                    product.inStock ? 'متوفر بالمستودع' : 'نفذت الكمية',
                    style: TextStyle(
                      fontSize: 9,
                      color: product.inStock ? AppTheme.emerald : AppTheme.rose,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(AppState state) {
    if (state.orders.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد شحنات توريد قيد الانتظار حالياً',
          style: TextStyle(color: AppTheme.textDim, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.orders.length,
      itemBuilder: (ctx, i) {
        final order = state.orders[i];
        final isPending = order.status == 'pending';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF181512),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPending ? AppTheme.gold.withOpacity(0.4) : const Color(0xFF2B2521),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    order.productName,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPending ? AppTheme.gold.withOpacity(0.15) : AppTheme.emerald.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPending ? 'قيد التجهيز' : 'تم التسليم',
                      style: TextStyle(
                        fontSize: 10,
                        color: isPending ? AppTheme.gold : AppTheme.emerald,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'الزبون: ${order.customerName} • هاتف: ${order.customerPhone}',
                style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (isPending)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emerald,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      onPressed: () {
                        state.updateOrderStatus(order.id, 'completed');
                      },
                      child: const Text('تأكيد التسليم', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.emerald, size: 18),
                    onPressed: () {
                      state.openWhatsApp(
                        phone: order.customerPhone,
                        message: 'مرحباً ${order.customerName}، بخصوص طلبك (${order.productName}) من مستودع التوريد.',
                      );
                    },
                    tooltip: 'تواصل عبر واتساب',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
