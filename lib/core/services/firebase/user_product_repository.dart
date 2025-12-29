import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/brands_model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

class UserProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! Stream active products from all sellers
  Stream<List<ProductModel>> streamActivePoducts() {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }

  // ! Stream active Products Brands from Admin Side
  Stream<List<BrandModel>> streamActiveBrands() {
    return _firestore
        .collection('brands')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BrandModel.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }

  
}
