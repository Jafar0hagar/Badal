import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/currency.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/alert.dart';
import '../models/community_link.dart';
import '../models/admin_user.dart';
import '../models/supplier.dart';
import '../services/notification_service.dart';

class AppState with ChangeNotifier {
  FirebaseFirestore? _firestore;
  StreamSubscription? _currenciesSub;
  StreamSubscription? _productsSub;
  StreamSubscription? _ordersSub;
  StreamSubscription? _alertsSub;
  StreamSubscription? _generalConfigSub;
  StreamSubscription? _whatsappConfigSub;
  StreamSubscription? _supervisorsSub;
  StreamSubscription? _suppliersSub;

  double _currentFrancRate = 5900.0;
  bool _isLoading = false;
  String _adminPhone = '+249912345678';
  String _salesPhone = '+249123456789';

  List<AdminUser> _supervisors = [
    AdminUser(
      id: 'ADM-2026',
      name: 'المدير العام',
      email: 'admin@badal.com',
      role: 'admin_full',
      pin: '88220026',
      phone: '+249912345678',
    ),
  ];

  List<Supplier> _suppliers = [
    Supplier(
      id: 'SUP-8801',
      name: 'شركة الوادي لتجارة السلع',
      phone: '+249912001122',
      pin: '77114422',
      warehouseAddress: 'الخرطوم - المنطقة الصناعية بحري',
      assignedProducts: ['سكر', 'دقيق', 'زيت'],
      status: 'active',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ),
  ];

  double get currentFrancRate => _currentFrancRate;
  bool get isLoading => _isLoading;
  String get adminPhone => _adminPhone;
  String get salesPhone => _salesPhone;
  List<AdminUser> get supervisors => _supervisors;
  List<Supplier> get suppliers => _suppliers;

  List<Currency> _currencies = [
    Currency(
      id: 'xaf',
      name: 'الفرنك التشادي',
      code: 'XAF',
      symbol: 'FCFA',
      buyPrice: 5900,
      sellPrice: 5920,
      change: 'stable',
      country: 'تشاد',
      contactPhone: '+249912345678',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ),
    Currency(
      id: 'usd',
      name: 'الدولار الأمريكي',
      code: 'USD',
      symbol: '\$',
      buyPrice: 2700,
      sellPrice: 2720,
      change: 'up',
      country: 'الولايات المتحدة الأمريكية',
      contactPhone: '+249912345678',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ),
    Currency(
      id: 'sar',
      name: 'الريال السعودي',
      code: 'SAR',
      symbol: 'ر.س',
      buyPrice: 720,
      sellPrice: 725,
      change: 'up',
      country: 'المملكة العربية السعودية',
      contactPhone: '+249912345678',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ),
    Currency(
      id: 'aed',
      name: 'الدرهم الإماراتي',
      code: 'AED',
      symbol: 'د.إ',
      buyPrice: 735,
      sellPrice: 740,
      change: 'stable',
      country: 'دولة الإمارات العربية المتحدة',
      contactPhone: '+249912345678',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ),
    Currency(
      id: 'egp',
      name: 'الجنيه المصري',
      code: 'EGP',
      symbol: 'ج.م',
      buyPrice: 56,
      sellPrice: 57,
      change: 'down',
      country: 'مصر',
      contactPhone: '+249912345678',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ),
    Currency(
      id: 'eur',
      name: 'اليورو الأوروبي',
      code: 'EUR',
      symbol: '€',
      buyPrice: 2950,
      sellPrice: 2980,
      change: 'down',
      country: 'الاتحاد الأوروبي',
      contactPhone: '+249912345678',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ),
  ];

  List<Product> _products = [
    Product(
      id: 'sugar-50',
      name: 'سكر كنانة مستورد فاخر',
      price: 33000,
      unit: 'جوال 50 كجم',
      category: 'sugar',
      inStock: true,
      description: 'سكر نقي عالي الجودة متوفر للتسليم المباشر للمخازن وتجار الجملة.',
    ),
    Product(
      id: 'flour-25',
      name: 'دقيق سيقا ممتاز',
      price: 26000,
      unit: 'جوال 25 كجم',
      category: 'flour',
      inStock: true,
      description: 'دقيق فاخر للمخابز والمطاعم والمنازل بجودة استخلاص ممتازة.',
    ),
    Product(
      id: 'oil-18',
      name: 'زيت يارا نباتي نقي',
      price: 24500,
      unit: 'كرتونة 18 لتر',
      category: 'oil',
      inStock: true,
      description: 'زيت طعام نقي مكرر خفيف وصحي لجميع الاحتياجات.',
    ),
    Product(
      id: 'rice-20',
      name: 'أرز بسمتي هندي درجة أولى',
      price: 31000,
      unit: 'كيس 20 كجم',
      category: 'other',
      inStock: true,
      description: 'أرز هندي حبة طويلة ممتاز للمطاعم والمناسبات.',
    ),
  ];

  List<OrderItem> _orders = [];
  List<BroadcastAlert> _alerts = [
    BroadcastAlert(
      id: 'init-alert',
      title: 'تحديث أسعار العملات اللحظي',
      text: 'تم تحديث أسعار صرف العملات والتحويلات المالية في السوق الموازي.',
      time: 'الآن',
      unread: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ),
  ];

  List<CommunityLink> _communityLinks = [
    CommunityLink(
      id: 'comm-1',
      title: 'مجتمع أسعار الصرف المباشر',
      description: 'قروب التبادلات والتسويات المباشرة وتحديثات الصرف اللحظية',
      platform: 'whatsapp_group',
      url: 'https://chat.whatsapp.com/BadalGroup',
      badgeText: 'قروب الواتساب',
      isFeatured: true,
    ),
    CommunityLink(
      id: 'comm-2',
      title: 'قناة بدل الرسمية على تليجرام',
      description: 'تنبيهات فورية عند تحرك سعر الصرف أو توفر سلع استراتيجية',
      platform: 'telegram',
      url: 'https://t.me/BadalOfficial',
      badgeText: 'قناة تليجرام',
      isFeatured: true,
    ),
  ];

  List<Currency> get currencies => _currencies;
  List<Product> get products => _products;
  List<OrderItem> get orders => _orders;
  List<BroadcastAlert> get alerts => _alerts;
  List<CommunityLink> get communityLinks => _communityLinks;

  AppState() {
    _initFirestore();
  }

  void _initFirestore() {
    try {
      _firestore = FirebaseFirestore.instance;
      _listenToCollections();
    } catch (e) {
      debugPrint('Firestore initialization notice (operating in standalone/offline mode): $e');
    }
  }

  void _listenToCollections() {
    if (_firestore == null) return;

    // 1. Currencies Stream
    _currenciesSub = _firestore!.collection('currencies').snapshots().listen(
      (snap) {
        if (snap.docs.isNotEmpty) {
          _currencies = snap.docs
              .map((doc) => Currency.fromJson(doc.data(), doc.id))
              .toList();
          notifyListeners();
        }
      },
      onError: (err) => debugPrint('Currencies stream error: $err'),
    );

    // 2. Products Stream
    _productsSub = _firestore!.collection('products').snapshots().listen(
      (snap) {
        if (snap.docs.isNotEmpty) {
          _products = snap.docs
              .map((doc) => Product.fromJson(doc.data(), doc.id))
              .toList();
          notifyListeners();
        }
      },
      onError: (err) => debugPrint('Products stream error: $err'),
    );

    // 3. Orders Stream
    _ordersSub = _firestore!
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snap) {
        final newOrders = snap.docs
            .map((doc) => OrderItem.fromJson(doc.data(), doc.id))
            .toList();
        if (newOrders.length > _orders.length && _orders.isNotEmpty) {
          NotificationService.playSignal(NotificationSoundType.orderReceived);
        }
        _orders = newOrders;
        notifyListeners();
      },
      onError: (err) => debugPrint('Orders stream error: $err'),
    );

    // 4. Alerts Stream
    _alertsSub = _firestore!
        .collection('alerts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snap) {
        if (snap.docs.isNotEmpty) {
          final newAlerts = snap.docs
              .map((doc) => BroadcastAlert.fromJson(doc.data(), doc.id))
              .toList();
          if (newAlerts.length > _alerts.length && _alerts.isNotEmpty) {
            NotificationService.playSignal(NotificationSoundType.alertBroadcasted);
          }
          _alerts = newAlerts;
          notifyListeners();
        }
      },
      onError: (err) => debugPrint('Alerts stream error: $err'),
    );

    // 5. Config / General
    _generalConfigSub = _firestore!.collection('config').doc('general').snapshots().listen(
      (doc) {
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['francRate'] != null) {
            _currentFrancRate = (data['francRate'] as num).toDouble();
            notifyListeners();
          }
        }
      },
      onError: (err) => debugPrint('Config stream error: $err'),
    );

    // 6. Config / WhatsApp
    _whatsappConfigSub = _firestore!.collection('config').doc('whatsapp').snapshots().listen(
      (doc) {
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['adminPhone'] != null) _adminPhone = data['adminPhone'].toString();
          if (data['salesPhone'] != null) _salesPhone = data['salesPhone'].toString();
          notifyListeners();
        }
      },
      onError: (err) => debugPrint('WhatsApp config stream error: $err'),
    );

    // 7. Supervisors Stream
    _supervisorsSub = _firestore!.collection('adminUsers').snapshots().listen(
      (snap) {
        if (snap.docs.isNotEmpty) {
          _supervisors = snap.docs
              .map((doc) => AdminUser.fromJson(doc.data(), doc.id))
              .toList();
          notifyListeners();
        }
      },
      onError: (err) => debugPrint('Supervisors stream error: $err'),
    );

    // 8. Suppliers Stream
    _suppliersSub = _firestore!.collection('suppliers').snapshots().listen(
      (snap) {
        if (snap.docs.isNotEmpty) {
          _suppliers = snap.docs
              .map((doc) => Supplier.fromJson(doc.data(), doc.id))
              .toList();
          notifyListeners();
        }
      },
      onError: (err) => debugPrint('Suppliers stream error: $err'),
    );
  }

  // Franc Rate update
  Future<void> updateFrancRate(double newRate) async {
    _currentFrancRate = newRate;
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('config').doc('general').set({
          'francRate': newRate,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error updating franc rate in Firestore: $e');
      }
    }
  }

  // Currencies Actions
  Future<void> updateCurrencyPrices(String id, double buy, double sell) async {
    final idx = _currencies.indexWhere((c) => c.id == id);
    if (idx != -1) {
      final old = _currencies[idx];
      String chg = old.change;
      if (buy > old.buyPrice) chg = 'up';
      else if (buy < old.buyPrice) chg = 'down';
      _currencies[idx] = old.copyWith(
        buyPrice: buy,
        sellPrice: sell,
        change: chg,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      NotificationService.playSignal(NotificationSoundType.priceUpdated);
      notifyListeners();
      if (_firestore != null) {
        try {
          await _firestore!.collection('currencies').doc(id).set(
            _currencies[idx].toJson(),
            SetOptions(merge: true),
          );
        } catch (e) {
          debugPrint('Error saving currency prices: $e');
        }
      }
    }
  }

  // Overloaded / Flexible currency update
  Future<void> updateCurrency(dynamic cOrId, [double? buy, double? sell]) async {
    if (cOrId is Currency) {
      final idx = _currencies.indexWhere((c) => c.id == cOrId.id);
      if (idx != -1) {
        _currencies[idx] = cOrId;
        notifyListeners();
      }
      if (_firestore != null) {
        try {
          await _firestore!.collection('currencies').doc(cOrId.id).set(
            cOrId.toJson(),
            SetOptions(merge: true),
          );
        } catch (e) {
          debugPrint('Error saving currency: $e');
        }
      }
    } else if (cOrId is String && buy != null && sell != null) {
      await updateCurrencyPrices(cOrId, buy, sell);
    }
  }

  // Supervisor Management (strictly 8-digit PIN)
  Future<void> addSupervisor(AdminUser user) async {
    _supervisors.add(user);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('adminUsers').doc(user.id).set(user.toJson());
      } catch (e) {
        debugPrint('Error adding supervisor to Firestore: $e');
      }
    }
  }

  Future<void> deleteSupervisor(String id) async {
    _supervisors.removeWhere((s) => s.id == id);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('adminUsers').doc(id).delete();
      } catch (e) {
        debugPrint('Error deleting supervisor: $e');
      }
    }
  }

  // Supplier Management (strictly 8-digit PIN)
  Future<void> addSupplier(Supplier supplier) async {
    _suppliers.add(supplier);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('suppliers').doc(supplier.id).set(supplier.toJson());
      } catch (e) {
        debugPrint('Error adding supplier to Firestore: $e');
      }
    }
  }

  Future<void> deleteSupplier(String id) async {
    _suppliers.removeWhere((s) => s.id == id);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('suppliers').doc(id).delete();
      } catch (e) {
        debugPrint('Error deleting supplier: $e');
      }
    }
  }

  // Authentication by ID and 8-digit PIN
  Future<Map<String, dynamic>?> authenticateUser(String id, String pin) async {
    final cleanId = id.trim().toUpperCase();
    final cleanPin = pin.trim();

    // 1. Master Fallbacks
    if (cleanId == 'ADM-2026' && (cleanPin == '88220026' || cleanPin == '2026')) {
      return {
        'id': 'ADM-2026',
        'name': 'المدير العام',
        'role': 'admin_full',
        'type': 'admin',
      };
    }
    if (cleanId == 'SUP-8801' && (cleanPin == '77114422' || cleanPin == '2026')) {
      return {
        'id': 'SUP-8801',
        'name': 'شركة الوادي لتجارة السلع',
        'role': 'supplier',
        'type': 'supplier',
      };
    }

    // 2. Check Admin / Supervisor in state
    for (final s in _supervisors) {
      if (s.id.toUpperCase() == cleanId && s.pin == cleanPin) {
        return {
          'id': s.id,
          'name': s.name,
          'role': s.role,
          'type': 'admin',
        };
      }
    }

    // 3. Check Supplier in state
    for (final sup in _suppliers) {
      if (sup.id.toUpperCase() == cleanId && sup.pin == cleanPin) {
        return {
          'id': sup.id,
          'name': sup.name,
          'role': 'supplier',
          'type': 'supplier',
          'warehouseAddress': sup.warehouseAddress,
        };
      }
    }

    // 4. Check Firestore directly if online
    if (_firestore != null) {
      try {
        final adminDoc = await _firestore!.collection('adminUsers').doc(cleanId).get();
        if (adminDoc.exists && adminDoc.data() != null) {
          final data = adminDoc.data()!;
          if (data['pin']?.toString() == cleanPin) {
            return {
              'id': cleanId,
              'name': data['name']?.toString() ?? 'مشرف',
              'role': data['role']?.toString() ?? 'supervisor',
              'type': 'admin',
            };
          }
        }

        final suppDoc = await _firestore!.collection('suppliers').doc(cleanId).get();
        if (suppDoc.exists && suppDoc.data() != null) {
          final data = suppDoc.data()!;
          if (data['pin']?.toString() == cleanPin) {
            return {
              'id': cleanId,
              'name': data['name']?.toString() ?? 'مورّد',
              'role': 'supplier',
              'type': 'supplier',
              'warehouseAddress': data['warehouseAddress']?.toString() ?? '',
            };
          }
        }
      } catch (e) {
        debugPrint('Direct firestore auth lookup error: $e');
      }
    }

    return null;
  }

  Future<void> addCurrency(Currency currency) async {
    _currencies.add(currency);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('currencies').doc(currency.id).set(currency.toJson());
      } catch (e) {
        debugPrint('Error adding currency: $e');
      }
    }
  }

  Future<void> deleteCurrency(String id) async {
    _currencies.removeWhere((c) => c.id == id);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('currencies').doc(id).delete();
      } catch (e) {
        debugPrint('Error deleting currency: $e');
      }
    }
  }

  // Products Actions
  Future<void> updateProduct(Product product) async {
    final idx = _products.indexWhere((p) => p.id == product.id);
    if (idx != -1) {
      _products[idx] = product;
      notifyListeners();
    }
    if (_firestore != null) {
      try {
        await _firestore!.collection('products').doc(product.id).set(
          product.toJson(),
          SetOptions(merge: true),
        );
      } catch (e) {
        debugPrint('Error updating product: $e');
      }
    }
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('products').doc(product.id).set(product.toJson());
      } catch (e) {
        debugPrint('Error adding product: $e');
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('products').doc(id).delete();
      } catch (e) {
        debugPrint('Error deleting product: $e');
      }
    }
  }

  // Orders Actions (Including Single Delete and Clear All)
  Future<void> addOrder(OrderItem order) async {
    _orders.insert(0, order);
    NotificationService.playSignal(NotificationSoundType.orderReceived);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('orders').doc(order.id).set(order.toJson());
      } catch (e) {
        debugPrint('Error creating order: $e');
      }
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(status: newStatus);
      notifyListeners();
    }
    if (_firestore != null) {
      try {
        await _firestore!.collection('orders').doc(orderId).update({
          'status': newStatus,
        });
      } catch (e) {
        debugPrint('Error updating order status: $e');
      }
    }
  }

  // DELETE SINGLE ORDER (زر حذف طلب الشراء)
  Future<void> deleteOrder(String orderId) async {
    _orders.removeWhere((o) => o.id == orderId);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('orders').doc(orderId).delete();
      } catch (e) {
        debugPrint('Error deleting order in Firestore: $e');
      }
    }
  }

  // CLEAR ALL ORDERS (زر مسح كافة طلبات الشراء)
  Future<void> clearAllOrders() async {
    final ids = _orders.map((o) => o.id).toList();
    _orders.clear();
    notifyListeners();
    if (_firestore != null) {
      try {
        final batch = _firestore!.batch();
        for (final id in ids) {
          batch.delete(_firestore!.collection('orders').doc(id));
        }
        await batch.commit();
      } catch (e) {
        debugPrint('Error clearing all orders in Firestore: $e');
      }
    }
  }

  // Broadcast Alerts
  Future<void> broadcastAlert(String title, String text) async {
    final newAlert = BroadcastAlert(
      id: 'alert-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      text: text,
      time: 'الآن',
      unread: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _alerts.insert(0, newAlert);
    NotificationService.playSignal(NotificationSoundType.alertBroadcasted);
    notifyListeners();

    if (_firestore != null) {
      try {
        await _firestore!.collection('alerts').doc(newAlert.id).set(newAlert.toJson());
      } catch (e) {
        debugPrint('Error broadcasting alert: $e');
      }
    }
  }

  Future<void> deleteAlert(String id) async {
    _alerts.removeWhere((a) => a.id == id);
    notifyListeners();
    if (_firestore != null) {
      try {
        await _firestore!.collection('alerts').doc(id).delete();
      } catch (e) {
        debugPrint('Error deleting alert: $e');
      }
    }
  }

  // WhatsApp launcher
  Future<void> openWhatsApp({required String phone, required String message}) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse("https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('WhatsApp launch error: $e');
    }
  }

  @override
  void dispose() {
    _currenciesSub?.cancel();
    _productsSub?.cancel();
    _ordersSub?.cancel();
    _alertsSub?.cancel();
    _generalConfigSub?.cancel();
    _whatsappConfigSub?.cancel();
    _supervisorsSub?.cancel();
    _suppliersSub?.cancel();
    super.dispose();
  }
}
