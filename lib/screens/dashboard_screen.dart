import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../models/currency.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/admin_user.dart';
import '../models/supplier.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeTab = 0; // 0: أسعار الصرف, 1: السلع, 2: الطلبات, 3: التنبيهات, 4: الفريق والموردين
  int _teamSubTab = 0; // 0: المشرفين, 1: الموردين

  // Quick Franc Controller
  final TextEditingController _francCtrl = TextEditingController();

  // Alert Controllers
  final TextEditingController _alertTitleCtrl = TextEditingController();
  final TextEditingController _alertTextCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _francCtrl.text = appState.currentFrancRate.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _francCtrl.dispose();
    _alertTitleCtrl.dispose();
    _alertTextCtrl.dispose();
    super.dispose();
  }

  void _showEditCurrencyDialog(BuildContext context, Currency c, AppState state) {
    final buyCtrl = TextEditingController(text: c.buyPrice.toStringAsFixed(0));
    final sellCtrl = TextEditingController(text: c.sellPrice.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.goldBorder),
          ),
          title: Text(
            'تعديل سعر: ${c.name} (${c.code})',
            style: const TextStyle(color: AppTheme.gold, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: buyCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(labelText: 'سعر الشراء (ج.س)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: sellCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(labelText: 'سعر البيع (ج.س)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: AppTheme.textDim)),
            ),
            ElevatedButton(
              onPressed: () {
                final buy = double.tryParse(buyCtrl.text.trim()) ?? c.buyPrice;
                final sell = double.tryParse(sellCtrl.text.trim()) ?? c.sellPrice;
                state.updateCurrency(c.id, buy, sell);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ تم تحديث سعر ${c.name} فورياً'), backgroundColor: AppTheme.emerald),
                );
              },
              child: const Text('حفظ السعر'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Product p, AppState state) {
    final priceCtrl = TextEditingController(text: p.price.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.goldBorder),
          ),
          title: Text(
            'تعديل سلعة: ${p.name}',
            style: const TextStyle(color: AppTheme.gold, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(labelText: 'السعر الحالي (${p.unit})'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: AppTheme.textDim)),
            ),
            ElevatedButton(
              onPressed: () {
                final newPrice = double.tryParse(priceCtrl.text.trim()) ?? p.price;
                state.updateProduct(p.copyWith(price: newPrice));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ تم تحديث سعر ${p.name} فورياً'), backgroundColor: AppTheme.emerald),
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('لوحة الإدارة والتحكم (مبسّطة)'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
            tooltip: 'العودة للإعدادات',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, size: 20, color: AppTheme.rose),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تسجيل الخروج والعودة للإعدادات')),
                );
              },
              tooltip: 'خروج',
            ),
          ],
        ),
        body: Column(
          children: [
            // Quick Navigation Segmented Bar (4 Simple Views)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: const Color(0xFF141210),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildSegmentBtn(0, 'الأسعار والفرنك', Icons.currency_exchange),
                    const SizedBox(width: 8),
                    _buildSegmentBtn(1, 'السلع التموينية', Icons.shopping_bag),
                    const SizedBox(width: 8),
                    _buildSegmentBtn(
                      2,
                      'الطلبات (${appState.orders.where((o) => o.status == 'pending').length})',
                      Icons.receipt_long,
                    ),
                    const SizedBox(width: 8),
                    _buildSegmentBtn(3, 'بث تنبيه', Icons.campaign),
                    const SizedBox(width: 8),
                    _buildSegmentBtn(4, 'الفريق والموردين', Icons.group),
                  ],
                ),
              ),
            ),

            // Tab Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: [
                  _buildCurrenciesTab(appState),
                  _buildProductsTab(appState),
                  _buildOrdersTab(appState),
                  _buildAlertsTab(appState),
                  _buildTeamTab(appState),
                ][_activeTab],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentBtn(int index, String label, IconData icon) {
    final isSelected = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.gold : const Color(0xFF1C1917),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.gold : AppTheme.goldBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF0C0A09) : AppTheme.gold,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF0C0A09) : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: CURRENCIES & FRANC
  Widget _buildCurrenciesTab(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Franc Exchange Rate Quick Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.gold.withOpacity(0.15),
                AppTheme.surface,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.gold.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt, color: AppTheme.gold, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'سعر صرف الفرنك التشادي السائد',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'الأساس المعتمد لحساب تكلفة كافة السلع والتحويلات للعملاء.',
                style: TextStyle(color: AppTheme.textDim, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _francCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppTheme.gold, fontSize: 18, fontWeight: FontWeight.w900),
                      decoration: const InputDecoration(
                        suffixText: 'ج.س / 1,000 فرنك',
                        suffixStyle: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onPressed: () {
                      final val = double.tryParse(_francCtrl.text.trim());
                      if (val != null && val > 0) {
                        state.updateFrancRate(val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✅ تم تحديث سعر صرف الفرنك إلى ${val.toStringAsFixed(0)} ج.س'),
                            backgroundColor: AppTheme.emerald,
                          ),
                        );
                      }
                    },
                    child: const Text('حفظ فورياً'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),
        const Text(
          'قائمة أسعار العملات (انقر للتعديل السريع)',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.currencies.length,
          itemBuilder: (ctx, i) {
            final c = state.currencies[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.goldBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF141210),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        c.code,
                        style: const TextStyle(color: AppTheme.gold, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'شراء: ${c.buyPrice.toStringAsFixed(0)} | بيع: ${c.sellPrice.toStringAsFixed(0)} ج.س',
                          style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: AppTheme.gold),
                    onPressed: () => _showEditCurrencyDialog(context, c, state),
                    tooltip: 'تعديل السعر',
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // TAB 2: PRODUCTS & INVENTORY
  Widget _buildProductsTab(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'إدارة السلع التموينية وحالة المخزون',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.products.length,
          itemBuilder: (ctx, i) {
            final p = state.products[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.goldBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141210),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.inventory_2, color: AppTheme.gold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${p.price.toStringAsFixed(0)} ج.س / ${p.unit}',
                          style: const TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  // Stock Toggle Button
                  InkWell(
                    onTap: () {
                      state.updateProduct(p.copyWith(inStock: !p.inStock));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.inStock
                            ? AppTheme.emerald.withOpacity(0.15)
                            : AppTheme.rose.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: p.inStock ? AppTheme.emerald : AppTheme.rose,
                        ),
                      ),
                      child: Text(
                        p.inStock ? 'متوفر' : 'نفد',
                        style: TextStyle(
                          color: p.inStock ? AppTheme.emeraldLight : AppTheme.rose,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.gold, size: 18),
                    onPressed: () => _showEditProductDialog(context, p, state),
                    tooltip: 'تعديل السعر',
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // TAB 3: ORDERS & WHATSAPP RESPONSE
  Widget _buildOrdersTab(AppState state) {
    if (state.orders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.inbox, color: AppTheme.textDim, size: 48),
            SizedBox(height: 12),
            Text('لا توجد طلبات شراء واردة حالياً', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الطلبات الواردة (${state.orders.length})',
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => state.clearAllOrders(),
              icon: const Icon(Icons.delete_sweep, size: 16, color: AppTheme.rose),
              label: const Text('مسح الكل', style: TextStyle(color: AppTheme.rose, fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.orders.length,
          itemBuilder: (ctx, i) {
            final o = state.orders[i];
            final isPending = o.status == 'pending';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isPending ? AppTheme.gold : AppTheme.goldBorder,
                  width: isPending ? 1.2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        o.productName,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPending
                              ? AppTheme.gold.withOpacity(0.15)
                              : AppTheme.emerald.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isPending ? 'قيد الانتظار' : 'مكتمل',
                          style: TextStyle(
                            color: isPending ? AppTheme.gold : AppTheme.emeraldLight,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'العميل: ${o.customerName} (${o.customerPhone})',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  if (o.notes.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'ملاحظات: ${o.notes}',
                      style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Direct WhatsApp Reply Button (رد عبر الواتساب فقط)
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            state.openWhatsApp(
                              phone: o.customerPhone,
                              message: 'السلام عليكم أخي الكريم ${o.customerName}، تواصل بخصوص طلبكم لسلعة (${o.productName}) عبر تطبيق بَدَلْ.',
                            );
                          },
                          icon: const Icon(Icons.chat, size: 14),
                          label: const Text('رد عبر واتساب', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status Toggle
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: isPending ? AppTheme.emerald : AppTheme.textDim),
                          foregroundColor: isPending ? AppTheme.emeraldLight : AppTheme.textDim,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          state.updateOrderStatus(o.id, isPending ? 'completed' : 'pending');
                        },
                        child: Text(isPending ? 'إكمال' : 'إعادة تعليق', style: const TextStyle(fontSize: 11)),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.rose),
                        onPressed: () => state.deleteOrder(o.id),
                        tooltip: 'حذف الطلب',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // TAB 4: BROADCAST ALERTS
  Widget _buildAlertsTab(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.goldBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.campaign, color: AppTheme.gold, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'بث تنبيه عاجل لكافة المستخدمين',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'يظهر فورياً في الشريط الإخباري لجميع الهواتف المتصلة بالتطبيق.',
                style: TextStyle(color: AppTheme.textDim, fontSize: 11),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _alertTitleCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'عنوان التنبيه',
                  hintText: 'مثال: تحديث عاجل للأسعار',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _alertTextCtrl,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'نص التنبيه',
                  hintText: 'مثال: تم تعديل سعر صرف الفرنك التشادي الآن ليكون 5900 ج.س...',
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  final title = _alertTitleCtrl.text.trim();
                  final text = _alertTextCtrl.text.trim();
                  if (title.isNotEmpty && text.isNotEmpty) {
                    state.broadcastAlert(title, text);
                    _alertTitleCtrl.clear();
                    _alertTextCtrl.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📢 تم بث التنبيه السحابي لكافة المستخدمين فورياً'),
                        backgroundColor: AppTheme.emerald,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.send, size: 16),
                label: const Text('بث التنبيه الآن', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // TAB 4: طاقم العمل والشركاء (إدارة المشرفين والموردين برموز ٨ أرقام)
  Widget _buildTeamTab(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sub-segmented Tab Switcher
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF141210),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2B2521)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _teamSubTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _teamSubTab == 0 ? AppTheme.gold : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'المشرفين (${state.supervisors.length})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _teamSubTab == 0 ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _teamSubTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _teamSubTab == 1 ? AppTheme.emerald : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'الموردين (${state.suppliers.length})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _teamSubTab == 1 ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_teamSubTab == 0) ...[
          // Supervisors Header & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مشرفو النظام والأسعار',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showAddSupervisorDialog(context, state),
                icon: const Icon(Icons.person_add_alt_1, size: 16),
                label: const Text('إضافة مشرف (PIN 8 أرقام)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (state.supervisors.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('لا يوجد مشرفون مسجلون حالياً', style: TextStyle(color: AppTheme.textDim))),
            )
          else
            ...state.supervisors.map((sup) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF181512),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2B2521)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppTheme.gold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              sup.name,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                sup.id,
                                style: const TextStyle(color: AppTheme.gold, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'رمز الأمان PIN: •••••••• (٨ أرقام)',
                          style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (sup.id != 'ADM-2026')
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppTheme.rose, size: 18),
                      onPressed: () {
                        state.deleteSupervisor(sup.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم حذف المشرف ${sup.name}'), backgroundColor: AppTheme.rose),
                        );
                      },
                      tooltip: 'حذف المشرف',
                    ),
                ],
              ),
            )),
        ] else ...[
          // Suppliers Header & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الموردون المعتمدون (بتنفيذ مخصص)',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.emerald,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showAddSupplierDialog(context, state),
                icon: const Icon(Icons.local_shipping, size: 16),
                label: const Text('إضافة مورّد (PIN 8 أرقام)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (state.suppliers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('لا يوجد موردون مسجلون حالياً', style: TextStyle(color: AppTheme.textDim))),
            )
          else
            ...state.suppliers.map((supp) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF181512),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2B2521)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.emerald.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.storefront_outlined, color: AppTheme.emerald, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              supp.name,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                supp.id,
                                style: const TextStyle(color: AppTheme.emerald, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'المستودع: ${supp.warehouseAddress} • PIN: ••••••••',
                          style: const TextStyle(color: AppTheme.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.emerald, size: 18),
                    onPressed: () {
                      state.openWhatsApp(
                        phone: supp.phone,
                        message: 'مرحباً شريكنا التوريدي ${supp.name}، بخصوص شحنات البضائع والأسعار.',
                      );
                    },
                    tooltip: 'تواصل واتساب مع المورّد',
                  ),
                  if (supp.id != 'SUP-8801')
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppTheme.rose, size: 18),
                      onPressed: () {
                        state.deleteSupplier(supp.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم حذف المورّد ${supp.name}'), backgroundColor: AppTheme.rose),
                        );
                      },
                      tooltip: 'حذف المورّد',
                    ),
                ],
              ),
            )),
        ],
      ],
    );
  }

  void _showAddSupervisorDialog(BuildContext context, AppState state) {
    final idCtrl = TextEditingController(text: 'SUPV-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
    final nameCtrl = TextEditingController();
    final pinCtrl = TextEditingController();
    String? err;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppTheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppTheme.goldBorder),
            ),
            title: const Text(
              'إضافة مشرف جديد (رمز ٨ أرقام)',
              style: TextStyle(color: AppTheme.gold, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (err != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    color: AppTheme.rose.withOpacity(0.2),
                    child: Text(err!, style: const TextStyle(color: AppTheme.rose, fontSize: 11)),
                  ),
                TextField(
                  controller: idCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'معرّف المشرف (ID)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'اسم المشرف الكامل'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: pinCtrl,
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppTheme.gold, letterSpacing: 4, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'رمز الأمان PIN (٨ أرقام حصراً)',
                    counterText: '',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء', style: TextStyle(color: AppTheme.textDim)),
              ),
              ElevatedButton(
                onPressed: () {
                  final id = idCtrl.text.trim();
                  final name = nameCtrl.text.trim();
                  final pin = pinCtrl.text.trim();

                  if (id.isEmpty || name.isEmpty || pin.isEmpty) {
                    setDialogState(() => err = 'يرجى تعبئة كافة الحقول');
                    return;
                  }
                  if (pin.length != 8) {
                    setDialogState(() => err = 'يجب أن يتكون رمز الأمان من ٨ أرقام بالضبط');
                    return;
                  }

                  state.addSupervisor(AdminUser(
                    id: id,
                    name: name,
                    email: '',
                    role: 'supervisor',
                    pin: pin,
                  ));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ تم إضافة المشرف $name بنجاح'), backgroundColor: AppTheme.emerald),
                  );
                },
                child: const Text('إضافة المشرف'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSupplierDialog(BuildContext context, AppState state) {
    final idCtrl = TextEditingController(text: 'SUP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final warehouseCtrl = TextEditingController();
    final pinCtrl = TextEditingController();
    String? err;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppTheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF10B981)),
            ),
            title: const Text(
              'إضافة مورد جديد (تنفيذ مخصص)',
              style: TextStyle(color: AppTheme.emerald, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (err != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      color: AppTheme.rose.withOpacity(0.2),
                      child: Text(err!, style: const TextStyle(color: AppTheme.rose, fontSize: 11)),
                    ),
                  TextField(
                    controller: idCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'معرّف المورد (ID)'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'اسم الشركة أو المورّد'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'رقم هاتف الواتساب'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: warehouseCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'عنوان المستودع أو المخزن'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: pinCtrl,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppTheme.emerald, letterSpacing: 4, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'رمز الأمان PIN (٨ أرقام حصراً)',
                      counterText: '',
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.emerald,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  final id = idCtrl.text.trim();
                  final name = nameCtrl.text.trim();
                  final phone = phoneCtrl.text.trim();
                  final warehouse = warehouseCtrl.text.trim();
                  final pin = pinCtrl.text.trim();

                  if (id.isEmpty || name.isEmpty || pin.isEmpty) {
                    setDialogState(() => err = 'يرجى إكمال البيانات الأساسية');
                    return;
                  }
                  if (pin.length != 8) {
                    setDialogState(() => err = 'يجب أن يتكون رمز الأمان من ٨ أرقام بالضبط');
                    return;
                  }

                  state.addSupplier(Supplier(
                    id: id,
                    name: name,
                    phone: phone,
                    warehouseAddress: warehouse.isEmpty ? 'المستودع الرئيسي' : warehouse,
                    pin: pin,
                    assignedProducts: ['سكر', 'دقيق', 'زيت'],
                    status: 'active',
                    createdAt: DateTime.now().millisecondsSinceEpoch,
                  ));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ تم إضافة المورّد $name بنجاح'), backgroundColor: AppTheme.emerald),
                  );
                },
                child: const Text('إضافة المورّد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
