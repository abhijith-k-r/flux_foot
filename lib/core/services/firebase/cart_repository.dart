import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/models/size_quantity_model.dart';

String getCartDocId(String productId, String? color, String? size) {
  final cleanColor = (color != null && color.trim().isNotEmpty) ? color.trim() : 'default';
  final cleanSize = (size != null && size.trim().isNotEmpty) ? size.trim() : 'default';
  return '${productId}_${cleanColor}_$cleanSize';
}

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
    final docId = getCartDocId(product.id, selectedColorName, selectedSize);
    DocumentReference cartRef = _cartCollection(uid).doc(docId);

    if (shouldRemove) {
      await cartRef.delete();
      // Clean up legacy doc ID if present
      final legacyRef = _cartCollection(uid).doc(product.id);
      final legacyDoc = await legacyRef.get();
      if (legacyDoc.exists) {
        await legacyRef.delete();
      }
    } else {
      await cartRef.set({
        'productId': product.id,
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
    List<String> cartDocIds,
    String uid,
  ) async {
    final cartSnapshot = await _cartCollection(uid).get();
    if (cartSnapshot.docs.isEmpty) return [];

    final Set<String> uniqueProductIds = {};
    final Map<String, Map<String, dynamic>> cartDetailsMap = {};

    for (var doc in cartSnapshot.docs) {
      final cartData = doc.data() as Map<String, dynamic>?;
      final productId = (cartData?['productId'] as String?) ?? doc.id;
      uniqueProductIds.add(productId);

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
        'productId': productId,
        'quantity': quantity,
        'selectedColor': cartData?['selectedColor'] as String? ?? 'N/A',
        'selectedSize': cartData?['selectedSize'] as String? ?? 'N/A',
      };
    }

    if (uniqueProductIds.isEmpty) return [];

    const int batchSize = 10;
    final List<String> productIdList = uniqueProductIds.toList();
    final Map<String, ProductModel> catalogProductsMap = {};

    for (int i = 0; i < productIdList.length; i += batchSize) {
      final batch = productIdList.sublist(
        i,
        i + batchSize > productIdList.length ? productIdList.length : i + batchSize,
      );

      final snapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      for (var doc in snapshot.docs) {
        catalogProductsMap[doc.id] = ProductModel.fromFirestore(doc.data(), doc.id);
      }
    }

    List<ProductModel> finalCartProducts = [];
    for (var doc in cartSnapshot.docs) {
      final docId = doc.id;
      final details = cartDetailsMap[docId];
      if (details == null) continue;

      final productId = details['productId'] as String;
      final catalogProduct = catalogProductsMap[productId];

      if (catalogProduct != null) {
        final quantity = details['quantity'] as int;
        final selectedColorName = details['selectedColor'] as String;
        final selectedSize = details['selectedSize'] as String;

        final selectedVariant = catalogProduct.variants.firstWhere(
          (variant) => variant.colorName == selectedColorName,
          orElse: () => catalogProduct.variants.isNotEmpty
              ? catalogProduct.variants.first
              : ColorvariantModel(colorName: selectedColorName),
        );

        final List<SizeQuantityVariant> filteredSizes = selectedVariant.sizes
            .where((s) => s.size == selectedSize)
            .toList();

        finalCartProducts.add(
          catalogProduct.copyWith(
            cartDocId: docId,
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
                : catalogProduct.images,
          ),
        );
      }
    }

    return finalCartProducts;
  }

  Future<void> updateCartQuantity(
    String cartDocId,
    int quantity,
    String uid,
  ) async {
    if (quantity > 0) {
      await _cartCollection(
        uid,
      ).doc(cartDocId).update({'quantity': quantity});
    }
  }

  Future<void> removeFromCart(String cartDocId, String uid) async {
    await _cartCollection(uid).doc(cartDocId).delete();
  }
}
