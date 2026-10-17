import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/currency_model.dart';
import '../../logic/providers.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  ConsumerState<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends ConsumerState<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String _selectedCurrencyId = 'usd';
  bool _isBuy = true; // true: buy from customer, false: sell to customer

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(currenciesStreamProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('حاسبة ومحول العملات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: currenciesAsync.when(
        data: (currencies) {
          if (currencies.isEmpty) {
            return const Center(child: Text('جاري تحميل العملات...'));
          }

          final selectedCurrency = currencies.firstWhere(
            (c) => c.id == _selectedCurrencyId,
            orElse: () => currencies.first,
          );

          final double amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
          final double rate = _isBuy ? selectedCurrency.buyPrice : selectedCurrency.sellPrice;
          final double resultInSdg = amount * rate;
          // Equivalence in Chadian Franc (assuming base benchmark ~5900 SDG per 1000 FCFA)
          final double resultInXaf = rate > 0 ? (resultInSdg / 5.9) : 0.0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Result Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBurgundy, AppColors.primaryBurgundyDark],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBurgundy.withOpacity(0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'المبلغ الإجمالي المعادل بالجنيه السوداني',
                      style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${resultInSdg.toStringAsFixed(0)} ج.س',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '≈ ${resultInXaf.toStringAsFixed(0)} فرنك تشادي (FCFA)',
                        style: GoogleFonts.cairo(
                          color: AppColors.accentAmber,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Buy/Sell Segment Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFECE7DE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isBuy = true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isBuy ? AppColors.primaryBurgundy : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'سعر الشراء (نشتري منك)',
                            style: GoogleFonts.cairo(
                              color: _isBuy ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isBuy = false),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isBuy ? AppColors.accentAmber : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'سعر البيع (نبيع لك)',
                            style: GoogleFonts.cairo(
                              color: !_isBuy ? Colors.black87 : (isDark ? Colors.white70 : Colors.black87),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Amount Input Field
              Text('المبلغ المراد تحويله:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                  suffixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerRight,
                    width: 70,
                    child: Text(
                      selectedCurrency.symbol,
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.accentAmber),
                    ),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 20),

              // Currency Selection
              Text('اختر العملة المراد تحويلها:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: currencies.map((curr) {
                  final bool isSelected = curr.id == _selectedCurrencyId;
                  return InkWell(
                    onTap: () => setState(() => _selectedCurrencyId = curr.id),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.accentAmber : AppColors.primaryBurgundy)
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(curr.flag, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            curr.name,
                            style: GoogleFonts.tajawal(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isSelected
                                  ? (isDark ? Colors.black87 : Colors.white)
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Rate details card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('سعر الصرف المعتمد في الحساب:', style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 11)),
                        Text('1 ${selectedCurrency.symbol} = ${rate.toStringAsFixed(0)} ج.س', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('حالة حركة السعر اليوم:', style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 11)),
                        Row(
                          children: [
                            Icon(
                              selectedCurrency.change == 'up' ? Icons.trending_up : (selectedCurrency.change == 'down' ? Icons.trending_down : Icons.trending_flat),
                              color: selectedCurrency.change == 'up' ? AppColors.greenGain : (selectedCurrency.change == 'down' ? AppColors.redLoss : Colors.grey),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              selectedCurrency.change == 'up' ? 'في صعود مستمر' : (selectedCurrency.change == 'down' ? 'في هبوط' : 'مستقر'),
                              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
      ),
    );
  }
}
