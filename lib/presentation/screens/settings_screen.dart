import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../logic/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _openWhatsAppSupport() async {
    const phone = '249912345678';
    const message = 'مرحباً، أود الاستفسار بخصوص أسعار الصرف أو السلع في تطبيق بدل.';
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = settings.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات والدعم', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          Text('تخصيص المظهر', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.accentAmber),
              title: Text('الوضع المظلم (Dark Mode)', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              trailing: Switch(
                value: isDark,
                activeColor: AppColors.accentAmber,
                onChanged: (_) => notifier.toggleDarkMode(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Notifications Section
          Text('التنبيهات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: AppColors.primaryBurgundy),
              title: Text('التنبيهات الفورية والرنين', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              subtitle: Text('تنبيهات عاجلة عند تقلب أسعار الصرف بالسوق', style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey)),
              trailing: Switch(
                value: settings.notificationsEnabled,
                activeColor: AppColors.primaryBurgundy,
                onChanged: (_) => notifier.toggleNotifications(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tools Section
          Text('الأدوات السريعة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calculate_outlined, color: AppColors.primaryBurgundy),
                  title: Text('حاسبة ومحول العملات المباشر', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/converter'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.support_agent, color: Colors.green),
                  title: Text('التواصل المباشر عبر واتساب', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                  subtitle: Text('للدعم الفني وتنفيذ الصفقات الكبرى', style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey)),
                  trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.green),
                  onTap: _openWhatsAppSupport,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Admin Section
          Text('لوحة الإدارة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: AppColors.accentAmber),
              title: Text('لوحة تحكم المشرفين (Badal Admin)', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              subtitle: Text('إدارة وتعديل الأسعار والسلع وبث الإشعارات', style: GoogleFonts.tajawal(fontSize: 10, color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/admin'),
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              'تطبيق بَدَلْ - الإصدار 1.0.0 (Native Flutter)',
              style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
