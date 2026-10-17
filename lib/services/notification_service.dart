import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/alert.dart';
import '../models/order.dart';

enum NotificationSoundType {
  orderReceived,
  priceUpdated,
  alertBroadcasted,
  accessGranted,
  errorWarning,
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Plays acoustic haptic and platform feedback signal
  static void playSignal(NotificationSoundType type) {
    try {
      switch (type) {
        case NotificationSoundType.orderReceived:
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.alert);
          break;
        case NotificationSoundType.priceUpdated:
          HapticFeedback.mediumImpact();
          SystemSound.play(SystemSoundType.click);
          break;
        case NotificationSoundType.alertBroadcasted:
          HapticFeedback.vibrate();
          SystemSound.play(SystemSoundType.alert);
          break;
        case NotificationSoundType.accessGranted:
          HapticFeedback.lightImpact();
          SystemSound.play(SystemSoundType.click);
          break;
        case NotificationSoundType.errorWarning:
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.alert);
          break;
      }
    } catch (e) {
      debugPrint('Acoustic feedback notice: $e');
    }
  }

  /// Displays an in-app banner alert with rich styling matching the Flutter theme
  static void showFloatingAlert({
    required BuildContext context,
    required String title,
    required String message,
    IconData icon = Icons.notifications_active_rounded,
    Color accentColor = const Color(0xFFE5A93C),
    Duration duration = const Duration(seconds: 4),
  }) {
    playSignal(NotificationSoundType.alertBroadcasted);

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 12,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * -40),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1B16),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: accentColor.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: accentColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFD5CEBE),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                    onPressed: () {
                      if (overlayEntry.mounted) overlayEntry.remove();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
