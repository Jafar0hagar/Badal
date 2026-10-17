import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'prices_screen.dart';
import 'products_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PricesScreen(),
    ProductsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final unreadAlerts = appState.alerts.where((a) => a.unread).length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141210),
            border: Border(
              top: BorderSide(
                color: AppTheme.goldBorder,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: const Color(0xFF141210),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.gold,
              unselectedItemColor: AppTheme.textDim,
              selectedFontSize: 11,
              unselectedFontSize: 10,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: [
                BottomNavigationBarItem(
                  icon: unreadAlerts > 0
                      ? Badge(
                          label: Text('$unreadAlerts', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          backgroundColor: AppTheme.gold,
                          textColor: Colors.black,
                          child: const Icon(Icons.home_outlined),
                        )
                      : const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.currency_exchange_outlined),
                  activeIcon: Icon(Icons.currency_exchange),
                  label: 'الأسعار',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  activeIcon: Icon(Icons.shopping_bag),
                  label: 'السلع',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'الإعدادات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

