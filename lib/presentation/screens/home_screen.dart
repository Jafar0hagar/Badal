import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../logic/providers.dart';
import '../widgets/currency_card.dart';
import '../widgets/alerts_bottom_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currenciesStreamProvider);
    final alertsAsync = ref.watch(alertsStreamProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryBurgundy,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.currency_exchange, color: AppColors.accentAmber, size: 16),
            ),
            const SizedBox(width: 8),
            Text('بَدَلْ', style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        actions: [
          alertsAsync.when(
            data: (alerts) {
              final unreadCount = alerts.where((a) => !settings.readAlertIds.contains(a.id)).length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const AlertsBottomSheet(),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.primaryBurgundy, shape: BoxShape.circle),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryBurgundy, AppColors.primaryBurgundyDark],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBurgundy.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('سعر الفرنك التشادي المباشر', style: GoogleFonts.cairo(color: AppColors.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
                      child: Text('السوق الموازي', style: GoogleFonts.tajawal(color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('5,900 ج.س', style: GoogleFonts.cairo(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                Text('تحديث فوري لأسعار التبادل بالحدود الغربية', style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('أسعار العملات اليومية', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          currenciesAsync.when(
            data: (currencies) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currencies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) => CurrencyCard(currency: currencies[index], isDarkMode: isDark),
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
            error: (err, _) => Center(child: Text('خطأ في استرجاع الأسعار: $err')),
          ),
        ],
      ),
    );
  }
}
