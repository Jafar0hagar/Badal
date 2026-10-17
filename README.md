# مشروع بَدَلْ - تطبيق الهاتف الأصلي (Flutter / Dart)

تم تجهيز هذا المجلد ليكون مشروع **Flutter** كامل وجاهز للنقل مباشرة إلى جهازك وبناء تطبيقات Native (Android APK / iOS IPA).

---

## 📁 هيكلية ملفات فلاتر المُنشأة:
- `pubspec.yaml`: ملف الحزم والتبعيات الأساسية (Riverpod, Firebase, GoRouter, AudioPlayers, GoogleFonts).
- `lib/main.dart`: نقطة الدخول الرئيسية وتجهيز Firebase و ProviderScope.
- `lib/firebase_options.dart`: إعدادات الربط المباشر مع مشروع Firebase Firestore:
  `ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8`
- `lib/core/theme/app_theme.dart`: نظام الألوان والتصميم (Burgundy & Amber Gold) والخطوط العربية.
- `lib/core/router/app_router.dart`: التوجيه باستخدام GoRouter.
- `lib/core/utils/audio_service.dart`: تشغيل رنين التنبيهات الفورية.
- `lib/data/models/`: موديلات البيانات (`currency_model.dart`, `product_model.dart`, `order_model.dart`, `alert_model.dart`).
- `lib/data/repositories/firestore_repository.dart`: مستودع الاتصال الحي السحابي مع مجموعات Firestore.
- `lib/logic/providers.dart`: إدارة الحالة وتزامن الجداول والتنبيهات عبر Riverpod.
- `lib/presentation/screens/`: شاشات التطبيق الكاملة (Splash, Home, Prices, Products, Settings, Admin Dashboard).
- `lib/presentation/widgets/`: الويدجتس التفاعلية (بطاقة العملة، نافذة الطلب، شريط الإشعار المنبثق، ورقة التنبيهات السفلية).

---

## 🚀 كيفية تشغيل المشروع على جهازك:

1. قم بنسخ مجلد `flutter_project/` إلى جهازك.
2. افتح المجلد في **VS Code** أو **Android Studio**.
3. نفذ الأمر التالي في الطرفية (Terminal):
   ```bash
   flutter pub get
   ```
4. لبناء تطبيق الأندرويد مباشرة:
   ```bash
   flutter build apk --release
   ```
5. لتشغيل التطبيق على الهاتف المتصل أو المحاكي:
   ```bash
   flutter run
   ```
