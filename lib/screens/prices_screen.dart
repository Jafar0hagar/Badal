import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../models/currency.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currencies = appState.currencies;

    final filtered = currencies.where((c) {
      final q = _searchQuery.toLowerCase().trim();
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q) ||
          c.country.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('أسعار العملات والتحويلات المالية'),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'ابحث باسم العملة أو الرمز أو الدولة...',
                prefixIcon: Icon(Icons.search, color: AppTheme.gold, size: 20),
              ),
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'لم يتم العثور على عملات مطابقة',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final c = filtered[i];
                      return _buildCurrencyCard(context, c, appState);
                    },
                  ),
          ),
        ],
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
