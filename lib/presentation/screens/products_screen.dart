import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../logic/providers.dart';
import '../widgets/product_order_dialog.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('السلع التموينية والمستودعات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: productsAsync.when(
        data: (products) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.accentAmber.withOpacity(0.2) : const Color(0xFFEADBCE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryBurgundy, size: 40),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(product.name, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1),
                    Text('${product.price.toStringAsFixed(0)} ج.س', style: GoogleFonts.cairo(color: AppColors.primaryBurgundy, fontWeight: FontWeight.w900, fontSize: 13)),
                    Text(product.unit, style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 10)),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => showDialog(context: context, builder: (_) => ProductOrderDialog(product: product)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBurgundy,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('طلب الآن', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
      ),
    );
  }
}
