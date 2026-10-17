import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/currency_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/alert_model.dart';

class FirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Currency>> getCurrenciesStream() {
    return _db.collection('currencies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Currency.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<Product>> getProductsStream() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<OrderItem>> getOrdersStream() {
    return _db.collection('orders').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderItem.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<SystemAlert>> getAlertsStream() {
    return _db.collection('alerts').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => SystemAlert.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Future<void> createOrder(OrderItem order) async {
    await _db.collection('orders').doc(order.id).set(order.toFirestore());
  }

  Future<void> broadcastAlert(String title, String text) async {
    final String alertId = 'alert-${DateTime.now().millisecondsSinceEpoch}';
    final alert = SystemAlert(
      id: alertId,
      title: title,
      text: text,
      time: 'الآن',
      unread: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.collection('alerts').doc(alertId).set(alert.toFirestore());
  }

  Future<void> updateCurrency(Currency currency) async {
    await _db.collection('currencies').doc(currency.id).set(currency.toFirestore(), SetOptions(merge: true));
  }

  Future<void> updateProduct(Product product) async {
    await _db.collection('products').doc(product.id).set(product.toFirestore(), SetOptions(merge: true));
  }
}
