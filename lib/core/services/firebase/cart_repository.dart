import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _cartCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('cart');
  }

  Future<void> toggleToCart(
    ProductModel product,
    bool shouldRemove,
    String uid,
  ) async {
    DocumentReference cartRef = _cartCollection(uid).doc(product.id);

    if (shouldRemove) {
      await cartRef.delete();
    } else {
      await cartRef.set({
        'quantity': '1',
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<List<String>> getCartItemId(String uid) {
    return _cartCollection(uid).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }

  Future<List<ProductModel>> getProuductsByIds(
    List<String> productIds,
    String uid,
  ) async {
    if (productIds.isEmpty) return [];


    const int batchSize = 10;
    List<ProductModel> catalogProducts = [];

    for (int i = 0; i < productIds.length; i += batchSize) {
      final batch = productIds.sublist(
        i,
        i + batchSize > productIds.length ? productIds.length : i + batchSize,
      );

      final snapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      catalogProducts.addAll(
        snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
    }
    
    final cartSnapshot = await _cartCollection(uid).get();

    final Map<String, int> quantityMap = {};
    for (var doc in cartSnapshot.docs) {
      final cartData = doc.data() as Map<String, dynamic>?;
      final quantityString = (cartData?['quantity'] as String?) ?? '1';
      quantityMap[doc.id] = int.tryParse(quantityString) ?? 1;
    }

    List<ProductModel> finalCartProducts = [];
    for (var product in catalogProducts) {
      final quantity = quantityMap[product.id] ?? 1;

      finalCartProducts.add(product.copyWith(quantity: quantity));
    }

    return finalCartProducts;
  }

  Future<void> updateCartQuantity(
    String productId,
    int quantity, 
    String uid,
  ) async {
    if (quantity > 0) {
      await _cartCollection(
        uid,
      ).doc(productId).update({'quantity': quantity.toString()});
    }
  }

  Future<void> removeFromCart(String productId, String uid) async {
    await _cartCollection(uid).doc(productId).delete();
  }
}
