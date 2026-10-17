import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/currency_model.dart';
import '../../core/theme/app_theme.dart';

class CurrencyCard extends StatelessWidget {
  final Currency currency;
  final bool isDarkMode;

  const CurrencyCard({
    super.key,
    required this.currency,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUp = currency.change == 'up';
    final Color trendColor = isUp ? AppColors.greenGain : (currency.change == 'down' ? AppColors.redLoss : Colors.grey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppColors.accentAmber.withOpacity(0.15) : const Color(0xFFEADBCE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.cardDark : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(currency.flag, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    currency.id.toUpperCase(),
                    style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${currency.sellPrice.toStringAsFixed(0)} ${currency.symbol}',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                  Row(
                    children: [
                      Icon(
                        isUp ? Icons.arrow_upward : (currency.change == 'down' ? Icons.arrow_downward : Icons.remove),
                        color: trendColor,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'شراء: ${currency.buyPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.tajawal(color: trendColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
