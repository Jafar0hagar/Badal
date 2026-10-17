import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/product_model.dart';
import '../../data/models/order_model.dart';
import '../../logic/providers.dart';

class ProductOrderDialog extends ConsumerStatefulWidget {
  final Product product;

  const ProductOrderDialog({super.key, required this.product});

  @override
  ConsumerState<ProductOrderDialog> createState() => _ProductOrderDialogState();
}

class _ProductOrderDialogState extends ConsumerState<ProductOrderDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء الاسم ورقم الهاتف')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final order = OrderItem(
      id: 'ord-${DateTime.now().millisecondsSinceEpoch}',
      productName: widget.product.name,
      price: widget.product.price.toStringAsFixed(0),
      unit: widget.product.unit,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      notes: _notesController.text.trim(),
      status: 'pending',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await ref.read(firestoreRepositoryProvider).createOrder(order);
    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم إرسال طلب الشراء إلى الإدارة بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('طلب شراء: ${widget.product.name}', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('${widget.product.price.toStringAsFixed(0)} ج.س / ${widget.product.unit}', style: GoogleFonts.tajawal(color: AppColors.primaryBurgundy, fontSize: 12)),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف / واتساب', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'ملاحظات (الكمية المطلوبة، العنوان)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBurgundy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('تأكيد الطلب الفوري', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
