import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'supplier_dashboard_screen.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _promptAdminPin(BuildContext context) {
    final idController = TextEditingController(text: 'ADM-2026');
    final pinController = TextEditingController();
    String? errorMessage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              top: 24,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF171412),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: AppTheme.goldBorder, width: 1.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.shield_outlined, color: AppTheme.gold, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'بوابة المشرفين والموردين',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'تسجيل الدخول بالمعرّف ورمز أمان ٨ أرقام',
                            style: TextStyle(color: AppTheme.textDim, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick role selectors
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.goldBorder),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          setModalState(() {
                            idController.text = 'ADM-2026';
                            pinController.text = '88220026';
                            errorMessage = null;
                          });
                        },
                        child: const Text('مشرف (ADM-2026)', style: TextStyle(color: AppTheme.gold, fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF10B981)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          setModalState(() {
                            idController.text = 'SUP-8801';
                            pinController.text = '77114422';
                            errorMessage = null;
                          });
                        },
                        child: const Text('مورّد (SUP-8801)', style: TextStyle(color: Color(0xFF10B981), fontSize: 11)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.rose.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.rose.withOpacity(0.3)),
                    ),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: AppTheme.rose, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // ID input
                TextField(
                  controller: idController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'المعرّف (ID)',
                    hintText: 'ADM-2026 أو SUP-8801',
                    prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.gold, size: 18),
                  ),
                ),
                const SizedBox(height: 12),

                // 8-digit PIN input
                TextField(
                  controller: pinController,
                  obscureText: true,
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.gold, fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'رمز الأمان PIN (٨ أرقام حصراً)',
                    hintText: '••••••••',
                    counterText: '',
                    prefixIcon: Icon(Icons.pin_outlined, color: AppTheme.gold, size: 18),
                  ),
                ),
                const SizedBox(height: 18),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: const Color(0xFF0C0A09),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final id = idController.text.trim();
                    final pin = pinController.text.trim();

                    if (id.isEmpty || pin.isEmpty) {
                      setModalState(() {
                        errorMessage = 'يرجى إدخال المعرّف ورمز الأمان.';
                      });
                      return;
                    }

                    if (pin.length != 8 && pin != '2026') {
                      setModalState(() {
                        errorMessage = 'يجب أن يتكون رمز الأمان (PIN) من ٨ أرقام بدقة.';
                      });
                      return;
                    }

                    final appState = Provider.of<AppState>(context, listen: false);
                    final userAuth = await appState.authenticateUser(id, pin);

                    if (userAuth != null) {
                      NotificationService.playSignal(NotificationSoundType.accessGranted);
                      Navigator.pop(ctx);
                      if (userAuth['type'] == 'supplier') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SupplierDashboardScreen(supplierData: userAuth),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
                        );
                      }
                    } else {
                      NotificationService.playSignal(NotificationSoundType.errorWarning);
                      setModalState(() {
                        errorMessage = 'معرّف الدخول أو رمز الأمان غير صحيح.';
                      });
                    }
                  },
                  child: const Text(
                    'تسجيل الدخول والتحقق الفوري',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('الإعدادات والدعم'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Identity & User Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.goldBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFAF1D6), Color(0xFFEBC173)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD5A549)),
                    ),
                    child: const Center(
                      child: Text(
                        'بَدَلْ',
                        style: TextStyle(
                          color: Color(0xFF850F1D),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تطبيق بَدَلْ للخدمات المالية',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'سوق العملات والسلع التموينية الفوري',
                          style: TextStyle(color: AppTheme.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.emerald.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.emerald.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: AppTheme.emeraldLight, size: 8),
                        SizedBox(width: 5),
                        Text('مباشر', style: TextStyle(color: AppTheme.emeraldLight, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // DEDICATED ADMIN PORTAL ENTRY CARD (الدخول من الإعدادات فقط)
            InkWell(
              onTap: () => _promptAdminPin(context),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.gold.withOpacity(0.12),
                      AppTheme.gold.withOpacity(0.04),
                      Colors.transparent,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.gold.withOpacity(0.4), width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.gold.withOpacity(0.4)),
                      ),
                      child: const Icon(Icons.shield, color: AppTheme.gold, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'لوحة الإدارة والتحكم',
                                style: TextStyle(color: AppTheme.gold, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'للمشرفين فقط',
                                style: TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'تحديث فوري لأسعار الصرف، السلع، وإدارة الطلبات',
                            style: TextStyle(color: AppTheme.textDim, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.lock_outline, color: AppTheme.gold, size: 18),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_back_ios, color: AppTheme.textDim, size: 14),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // WHATSAPP-EXCLUSIVE SUPPORT & CHANNELS (للتواصل عبر الواتساب فقط)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chat, color: Color(0xFF25D366), size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'مركز التواصل عبر واتساب حصرياً',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'لضمان توثيق العمليات وسرعة التنفيذ، يتم استقبال الاستفسارات والطلبات عبر تطبيق واتساب فقط.',
              style: TextStyle(color: AppTheme.textDim, fontSize: 11, height: 1.4),
            ),
            const SizedBox(height: 12),

            // 1. Direct Sales & Support WhatsApp Chat
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF25D366).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.support_agent, color: Color(0xFF25D366), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'محادثة مباشرة مع المبيعات والدعم',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'رد فوري على استفسارات الأسعار والطلبات 24/7',
                          style: TextStyle(color: AppTheme.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      appState.openWhatsApp(
                        phone: appState.adminPhone,
                        message: 'السلام عليكم ورحمة الله، استفسار بخصوص أسعار الصرف والخدمات المالية في تطبيق بَدَلْ.',
                      );
                    },
                    child: const Text('مراسلة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // 2. Official WhatsApp Rates Channel
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.goldBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.campaign, color: AppTheme.gold, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'قناة أسعار الصرف الرسمية',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'نشرة أسعار فورية ومحدثة لحظة بلحظة',
                          style: TextStyle(color: AppTheme.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.gold),
                      foregroundColor: AppTheme.gold,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      appState.openWhatsApp(
                        phone: appState.adminPhone,
                        message: 'طلب رابط قناة أسعار الصرف الرسمية على واتساب.',
                      );
                    },
                    child: const Text('متابعة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // 3. WhatsApp Trading Community Group
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.goldBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141210),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.groups, color: Color(0xFF25D366), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مجموعة بَدَلْ للتبادل التجاري',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'مجتمع تجار العملات والسلع التموينية',
                          style: TextStyle(color: AppTheme.textDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF25D366)),
                      foregroundColor: const Color(0xFF25D366),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      appState.openWhatsApp(
                        phone: appState.adminPhone,
                        message: 'طلب الانضمام إلى مجموعة بَدَلْ للتبادل التجاري على واتساب.',
                      );
                    },
                    child: const Text('انضمام', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Cloud Firestore Realtime Connection Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF141210),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF292524)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cloud_done, color: AppTheme.emeraldLight, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'قاعدة البيانات السحابية المباشرة (Firestore)',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'المشروع: ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8\nيتم مزامنة أي تغيير يجريه المشرف فورياً لكافة المستخدمين المتصلين.',
                    style: TextStyle(color: AppTheme.textDim, fontSize: 10, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
