import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final prefs = await SharedPreferences.getInstance();
    final bool completedOnboarding = prefs.getBool('badal_onboarding_completed') ?? false;

    if (mounted) {
      if (!completedOnboarding) {
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryBurgundy,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBurgundy.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.currency_exchange, color: AppColors.accentAmber, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              'بَدَلْ',
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryBurgundy,
              ),
            ),
            Text(
              'منصة أسعار الصرف والسلع بالسودان',
              style: GoogleFonts.tajawal(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textLightSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
