import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../logic/providers.dart';
import '../../core/utils/audio_service.dart';
import '../../data/models/alert_model.dart';
import '../widgets/alert_notification_banner.dart';
import '../widgets/alerts_bottom_sheet.dart';
import 'home_screen.dart';
import 'prices_screen.dart';
import 'products_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;
  SystemAlert? _activeBannerAlert;
  String? _lastAlertId;

  final List<Widget> _screens = const [
    HomeScreen(),
    PricesScreen(),
    ProductsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkMode;

    ref.listen<AsyncValue<List<SystemAlert>>>(alertsStreamProvider, (previous, next) {
      next.whenData((alerts) {
        if (alerts.isNotEmpty) {
          final latest = alerts.first;
          if (_lastAlertId != null && _lastAlertId != latest.id && settings.notificationsEnabled) {
            AudioService().playNotificationChime();
            setState(() => _activeBannerAlert = latest);
            Future.delayed(const Duration(seconds: 7), () {
              if (mounted && _activeBannerAlert?.id == latest.id) {
                setState(() => _activeBannerAlert = null);
              }
            });
          }
          _lastAlertId = latest.id;
        }
      });
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            _screens[_currentIndex],
            if (_activeBannerAlert != null)
              AlertNotificationBanner(
                alert: _activeBannerAlert!,
                onTap: () {
                  ref.read(settingsProvider.notifier).markAlertAsRead(_activeBannerAlert!.id);
                  setState(() => _activeBannerAlert = null);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AlertsBottomSheet(),
                  );
                },
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          selectedItemColor: isDark ? AppColors.accentAmber : AppColors.primaryBurgundy,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), activeIcon: Icon(Icons.ssid_chart), label: 'الأسعار'),
            BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'السلع'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }
}
