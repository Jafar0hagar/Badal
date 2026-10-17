import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/providers.dart';
import '../widgets/currency_card.dart';

class PricesScreen extends ConsumerWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currenciesStreamProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('شاشة التداولات والعملات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: currenciesAsync.when(
        data: (currencies) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: currencies.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => CurrencyCard(
            currency: currencies[index],
            isDarkMode: settings.isDarkMode,
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
      ),
    );
  }
}
