import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/alert_model.dart';
import '../../core/theme/app_theme.dart';

class AlertNotificationBanner extends StatelessWidget {
  final SystemAlert alert;
  final VoidCallback onTap;

  const AlertNotificationBanner({
    super.key,
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1A16).withOpacity(0.96),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentAmber.withOpacity(0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBurgundy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.notifications_active, color: AppColors.accentAmber, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تنبيه عاجل • تطبيق بدل',
                            style: GoogleFonts.cairo(color: AppColors.accentAmber, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            alert.time,
                            style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 9),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert.title,
                        style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        alert.text,
                        style: GoogleFonts.tajawal(color: Colors.white70, fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
