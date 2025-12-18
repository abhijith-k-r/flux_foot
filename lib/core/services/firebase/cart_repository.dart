import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/models/size_quantity_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _cartCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('cart');
  }

  Future<void> toggleToCart({
    required ProductModel product,
    required bool shouldRemove,
    required String uid,
    String? selectedColorName,
    String? selectedSize,
  }) async {
    DocumentReference cartRef = _cartCollection(uid).doc(product.id);

    if (shouldRemove) {
      await cartRef.delete();
    } else {
      await cartRef.set({
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
        'selectedColor': selectedColorName,
        'selectedSize': selectedSize,
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

    // final Map<String, int> quantityMap = {};
    // for (var doc in cartSnapshot.docs) {
    //   final cartData = doc.data() as Map<String, dynamic>?;
    //   final quantityString = (cartData?['quantity'] as String?) ?? '1';
    //   quantityMap[doc.id] = int.tryParse(quantityString) ?? 1;
    // }

    final Map<String, dynamic> cartDetailsMap = {};
    for (var doc in cartSnapshot.docs) {
      final cartData = doc.data() as Map<String, dynamic>?;

      int quantity;
      final rawQuantity = cartData?['quantity'];

      if (rawQuantity is num) {
        quantity = rawQuantity.toInt(); 
      } else if (rawQuantity is String) {
        quantity = int.tryParse(rawQuantity) ?? 1; 
      } else {
        quantity = 1; 
      }

      cartDetailsMap[doc.id] = {
        'quantity': quantity,
        'selectedColor': cartData?['selectedColor'] as String? ?? 'N/A',
        'selectedSize': cartData?['selectedSize'] as String? ?? 'N/A',
      };
    }

    List<ProductModel> finalCartProducts = [];
    for (var product in catalogProducts) {
      final details = cartDetailsMap[product.id];

      if (details != null) {
        final quantity = details['quantity'] as int;
        final selectedColorName = details['selectedColor'] as String;
        final selectedSize = details['selectedSize'] as String;

        final selectedVariant = product.variants.firstWhere(
          (variant) => variant.colorName == selectedColorName,
          orElse: () => product.variants.isNotEmpty
              ? product.variants.first
              : ColorvariantModel(colorName: selectedColorName),
        );

        final List<SizeQuantityVariant> filteredSizes = selectedVariant.sizes
            .where((s) => s.size == selectedSize)
            .toList();

        finalCartProducts.add(
          product.copyWith(
            quantity: quantity,
            variants: [
              selectedVariant.copyWith(
                sizes: filteredSizes.isNotEmpty
                    ? filteredSizes
                    : selectedVariant.sizes,
              ),
            ],
            images: selectedVariant.imageUrls.isNotEmpty
                ? selectedVariant.imageUrls
                : product.images,
          ),
        );
      }
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
