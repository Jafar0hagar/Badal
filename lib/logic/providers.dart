import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/currency_model.dart';
import '../data/models/product_model.dart';
import '../data/models/order_model.dart';
import '../data/models/alert_model.dart';
import '../data/repositories/firestore_repository.dart';

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository();
});

final currenciesStreamProvider = StreamProvider<List<Currency>>((ref) {
  return ref.watch(firestoreRepositoryProvider).getCurrenciesStream();
});

final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(firestoreRepositoryProvider).getProductsStream();
});

final ordersStreamProvider = StreamProvider<List<OrderItem>>((ref) {
  return ref.watch(firestoreRepositoryProvider).getOrdersStream();
});

final alertsStreamProvider = StreamProvider<List<SystemAlert>>((ref) {
  return ref.watch(firestoreRepositoryProvider).getAlertsStream();
});

class SettingsState {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final List<String> readAlertIds;

  SettingsState({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.readAlertIds,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    List<String>? readAlertIds,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      readAlertIds: readAlertIds ?? this.readAlertIds,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState(isDarkMode: false, notificationsEnabled: true, readAlertIds: [])) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('badal_dark_mode') ?? false;
    final notifications = prefs.getBool('badal_notifications_enabled') ?? true;
    final readIds = prefs.getStringList('badal_read_alerts') ?? [];
    state = SettingsState(isDarkMode: isDark, notificationsEnabled: notifications, readAlertIds: readIds);
  }

  Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = !state.isDarkMode;
    await prefs.setBool('badal_dark_mode', newMode);
    state = state.copyWith(isDarkMode: newMode);
  }

  Future<void> toggleNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final newNotifications = !state.notificationsEnabled;
    await prefs.setBool('badal_notifications_enabled', newNotifications);
    state = state.copyWith(notificationsEnabled: newNotifications);
  }

  Future<void> markAlertAsRead(String id) async {
    if (!state.readAlertIds.contains(id)) {
      final updated = [...state.readAlertIds, id];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('badal_read_alerts', updated);
      state = state.copyWith(readAlertIds: updated);
    }
  }

  Future<void> markAllAlertsAsRead(List<String> ids) async {
    final updated = {...state.readAlertIds, ...ids}.toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('badal_read_alerts', updated);
    state = state.copyWith(readAlertIds: updated);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
