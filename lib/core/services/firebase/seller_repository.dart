import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/seller_model.dart';

class SellerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SellerModel> getSellerById(String sellerId) async {
    try {
      final doc = await _firestore.collection('sellers').doc(sellerId).get();
      if (doc.exists && doc.data() != null) {
        return SellerModel.fromFirestore(doc.data()!, doc.id);
      } else {
        throw Exception("Seller not found");
      }
    } catch (e) {
      throw Exception("Error fetching seller: $e");
    }
  }

  
}
