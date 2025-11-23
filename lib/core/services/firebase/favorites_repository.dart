import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

class FavoritesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleFavorite(
    ProductModel product,
    bool isFavorite,
    String uid,
  ) async {
    DocumentReference favRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(product.id);

    if (isFavorite) {
      await favRef.delete();
    } else {
      await favRef.set({'id': product.id, 'name': product.name});
    }
  }

  Stream<List<String>> getFavoriteItemIds(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<List<ProductModel>> getProductsByIds(List<String> productIds) async {
    if (productIds.isEmpty) return [];

    const int batchSize = 10;
    List<ProductModel> products = [];

    for (int i = 0; i < productIds.length; i += batchSize) {
      final batch = productIds.sublist(
        i,
        i + batchSize > productIds.length ? productIds.length : i + batchSize,
      );

      final snapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      products.addAll(
        snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
    }

    return products;
  }
}
