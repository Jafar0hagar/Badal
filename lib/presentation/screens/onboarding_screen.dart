import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'أسعار الصرف المباشرة والحية',
      'desc': 'تابع أسعار الدولار، الريال، الفرنك التشادي، وكافة العملات الأجنبية لحظة بلحظة مع تحديثات السوق الموازي.',
      'icon': 'trending_up',
    },
    {
      'title': 'مستودع السلع التموينية',
      'desc': 'اطلع على أسعار السكر، الدقيق، الزيوت، والمحروقات مع إمكانية إرسال طلبات شراء فورية مباشرة للإدارة.',
      'icon': 'inventory_2',
    },
    {
      'title': 'تنبيهات فورية ورنين عاجل',
      'desc': 'استلم إشعارات صوتية عاجلة لحظة حدوث أي حركة أو تقلبات مفاجئة في أسعار العملات في السوق.',
      'icon': 'notifications_active',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('badal_onboarding_completed', true);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text('تخطي', style: GoogleFonts.tajawal(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  IconData icon = Icons.currency_exchange;
                  if (page['icon'] == 'trending_up') icon = Icons.trending_up;
                  if (page['icon'] == 'inventory_2') icon = Icons.inventory_2_outlined;
                  if (page['icon'] == 'notifications_active') icon = Icons.notifications_active_outlined;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBurgundy,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBurgundy.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(icon, color: AppColors.accentAmber, size: 50),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBurgundy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page['desc']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (idx) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == idx ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == idx ? AppColors.primaryBurgundy : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    } else {
                      _completeOnboarding();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBurgundy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'ابدأ الآن' : 'التالي',
                    style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
