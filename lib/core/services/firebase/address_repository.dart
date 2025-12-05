import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _addressCollection =>
      _firestore.collection('Addresses');

      Future<void> saveAddress({required AddressModel address}) async {
    try {
      await _addressCollection.add(address.toFireStore());
    } catch (e) {
      throw Exception('Failed to save address: $e');
    }
  }

  Stream<List<AddressModel>> getAddressesForCurrentUser() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return Stream.value([]);
    }

 
    return _addressCollection
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          try {
            final addresses = snapshot.docs.map((doc) {
              return AddressModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
            }).toList();
            
            addresses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return addresses;
          } catch (e) {
            return <AddressModel>[];
          }
        })
        .handleError((error) {
          throw error;
        });
  }

  Future<void> updateAddress({required AddressModel address}) async {
    if (address.id == null) {
      throw Exception('Address ID is required for update');
    }
    try {
      await _addressCollection.doc(address.id).update(address.toFireStore());
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  Future<void> deleteAddress({required String addressId}) async {
    try {
      await _addressCollection.doc(addressId).delete();
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }
}
