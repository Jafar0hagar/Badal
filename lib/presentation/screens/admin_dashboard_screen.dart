import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../logic/providers.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  bool _isBroadcasting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _broadcast() async {
    if (_titleController.text.trim().isEmpty || _textController.text.trim().isEmpty) return;
    setState(() => _isBroadcasting = true);
    await ref.read(firestoreRepositoryProvider).broadcastAlert(
          _titleController.text.trim(),
          _textController.text.trim(),
        );
    setState(() {
      _isBroadcasting = false;
      _titleController.clear();
      _textController.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم بث التنبيه لجميع العملاء وتحديث السحابة فوراً')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم المشرف (Badal Admin)', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF181410),
        foregroundColor: AppColors.accentAmber,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1914),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentAmber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('بث تنبيه عاجل لجميع العملاء', style: GoogleFonts.cairo(color: AppColors.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'عنوان التنبيه', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _textController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'نص التنبيه', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isBroadcasting ? null : _broadcast,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentAmber, foregroundColor: Colors.black),
                    child: _isBroadcasting ? const CircularProgressIndicator() : Text('بث التنبيه الفوري الآن', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('طلبات الشراء المستلمة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          ordersAsync.when(
            data: (orders) {
              if (orders.isEmpty) return const Center(child: Text('لا توجد طلبات جديدة'));
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    tileColor: const Color(0xFF1E1914),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: Text('${order.productName} - ${order.customerName}', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12)),
                    subtitle: Text('هاتف: ${order.customerPhone} | ملاحظات: ${order.notes}', style: GoogleFonts.tajawal(fontSize: 10)),
                    trailing: Text('${order.price} ج.س', style: GoogleFonts.cairo(color: AppColors.accentAmber, fontWeight: FontWeight.bold)),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('خطأ: $err')),
          ),
        ],
      ),
    );
  }
}
