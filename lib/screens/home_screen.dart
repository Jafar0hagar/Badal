import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../models/currency.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _calcController = TextEditingController();
  double _calculatedSDG = 0.0;

  @override
  void dispose() {
    _calcController.dispose();
    super.dispose();
  }

  void _onCalculate(String val, double rate) {
    if (val.trim().isEmpty) {
      setState(() => _calculatedSDG = 0.0);
      return;
    }
    final amt = double.tryParse(val.trim());
    if (amt != null) {
      setState(() {
        _calculatedSDG = amt * (rate / 1000.0);
      });
    }
  }

  void _showUpdateFrancDialog(BuildContext context, AppState appState) {
    final controller = TextEditingController(text: appState.currentFrancRate.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.goldBorder),
        ),
        title: const Text(
          'تحديث سعر الفرنك التشادي السائد',
          style: TextStyle(color: AppTheme.gold, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أدخل سعر الألف فرنك مقابل الجنيه السوداني (ج.س):',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'مثال: 5900',
                suffixText: 'ج.س',
                suffixStyle: TextStyle(color: AppTheme.gold),
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
              final newRate = double.tryParse(controller.text.trim());
              if (newRate != null && newRate > 0) {
                appState.updateFrancRate(newRate);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ تم تحديث سعر صرف الفرنك بنجاح'),
                    backgroundColor: AppTheme.emerald,
                  ),
                );
              }
            },
            child: const Text('حفظ ونشر'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final francRate = appState.currentFrancRate;
    final featuredCurrencies = appState.currencies.take(5).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.goldBorder),
              ),
              child: const Text(
                'بَدَلْ',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'للخدمات المالية والتسويات',
              style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appState.alerts.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.goldBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign_rounded, color: AppTheme.gold, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.alerts.first.title,
                            style: const TextStyle(
                              color: AppTheme.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            appState.alerts.first.text,
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Prevailing Franc Hero Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1A16), Color(0xFF12100E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.goldBorder, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('🇹🇩', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الفرنك التشادي المعتمد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'سعر التحويل والتبادل اللحظي',
                                style: TextStyle(color: AppTheme.textDim, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.emerald.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.emerald.withOpacity(0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: AppTheme.emeraldLight, size: 7),
                            SizedBox(width: 4),
                            Text(
                              'سعر حي',
                              style: TextStyle(
                                color: AppTheme.emeraldLight,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'سعر كل 1,000 فرنك تشادي:',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: francRate.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: AppTheme.gold,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' جنيه سوداني',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () => _showUpdateFrancDialog(context, appState),
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.surfaceLighter,
                          foregroundColor: AppTheme.gold,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.edit, size: 14),
                        label: const Text('تعديل السعر', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFF292524), height: 1),
                  const SizedBox(height: 12),

                  // Mini Converter
                  const Text(
                    'حاسبة التحويل السريع (فرنك ⬅️ جنيه):',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: TextField(
                            controller: _calcController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) => _onCalculate(val, francRate),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'أدخل المبلغ بالفرنك...',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.goldBorder),
                        ),
                        child: Text(
                          _calculatedSDG > 0
                              ? '${_calculatedSDG.toStringAsFixed(0)} ج.س'
                              : '0 ج.س',
                          style: const TextStyle(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Featured Currencies
            const Text(
              'أسعار العملات والتحويلات المباشرة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featuredCurrencies.length,
              itemBuilder: (context, idx) {
                final c = featuredCurrencies[idx];
                return _buildCurrencyCard(context, c, appState);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context, Currency c, AppState appState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF141210),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        _getCurrencyFlag(c.id),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${c.code} • ${c.country}',
                        style: const TextStyle(color: AppTheme.textDim, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: c.change == 'up'
                      ? AppTheme.emerald.withOpacity(0.15)
                      : (c.change == 'down' ? AppTheme.rose.withOpacity(0.15) : Colors.white10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  c.change == 'up' ? 'صعود ↗' : (c.change == 'down' ? 'هبوط ↘' : 'مستقر ↔'),
                  style: TextStyle(
                    color: c.change == 'up'
                        ? AppTheme.emeraldLight
                        : (c.change == 'down' ? AppTheme.rose : AppTheme.textMuted),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Buy / Sell prices row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12100E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'سعر الشراء',
                        style: TextStyle(color: AppTheme.textDim, fontSize: 10),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${c.buyPrice.toStringAsFixed(0)} ج.س',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12100E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'سعر البيع',
                        style: TextStyle(color: AppTheme.textDim, fontSize: 10),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${c.sellPrice.toStringAsFixed(0)} ج.س',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Compact "عبر الواتساب" button
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.emerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                appState.openWhatsApp(
                  phone: c.contactPhone.isNotEmpty ? c.contactPhone : appState.adminPhone,
                  message: 'السلام عليكم، أرغب في استفسار تحويل مالي لعملة ${c.name}.',
                );
              },
              icon: const Icon(Icons.chat, size: 14),
              label: const Text(
                'واتساب',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencyFlag(String id) {
    switch (id.toLowerCase()) {
      case 'xaf': return '🇹🇩';
      case 'usd': return '🇺🇸';
      case 'sar': return '🇸🇦';
      case 'aed': return '🇦🇪';
      case 'egp': return '🇪🇬';
      case 'eur': return '🇪🇺';
      case 'gbp': return '🇬🇧';
      case 'kwd': return '🇰🇼';
      default: return '🪙';
    }
  }
}
