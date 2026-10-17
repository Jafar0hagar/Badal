import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/alert_model.dart';
import '../../logic/providers.dart';

class AlertsBottomSheet extends ConsumerWidget {
  const AlertsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(alertsStreamProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التنبيهات الفورية',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.accentAmber : AppColors.primaryBurgundy,
                ),
              ),
              alertsAsync.when(
                data: (alerts) {
                  final unreadIds = alerts.where((a) => !settings.readAlertIds.contains(a.id)).map((a) => a.id).toList();
                  if (unreadIds.isEmpty) return const SizedBox.shrink();
                  return TextButton(
                    onPressed: () => ref.read(settingsProvider.notifier).markAllAlertsAsRead(unreadIds),
                    child: Text(
                      'تحديد الكل كمقروء',
                      style: GoogleFonts.tajawal(color: AppColors.accentAmber, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: alertsAsync.when(
              data: (alerts) {
                if (alerts.isEmpty) {
                  return Center(
                    child: Text('لا توجد تنبيهات حالياً', style: GoogleFonts.tajawal(color: Colors.grey)),
                  );
                }
                return ListView.separated(
                  itemCount: alerts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    final isUnread = !settings.readAlertIds.contains(alert.id);
                    return InkWell(
                      onTap: () => ref.read(settingsProvider.notifier).markAlertAsRead(alert.id),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? (isDark ? AppColors.cardDark : const Color(0xFFFFF9E6))
                              : (isDark ? Colors.black26 : const Color(0xFFF9F9F9)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isUnread ? AppColors.accentAmber.withOpacity(0.5) : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  alert.title,
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isDark ? Colors.white : AppColors.textLightPrimary,
                                  ),
                                ),
                                Text(alert.time, style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert.text,
                              style: GoogleFonts.tajawal(
                                fontSize: 11,
                                color: isDark ? Colors.white70 : AppColors.textLightSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('خطأ في استرجاع التنبيهات: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
