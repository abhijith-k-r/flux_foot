import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';

class AddressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _getAddressesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('addresses');
  }

  Future<void> saveAddress({required AddressModel address}) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    try {
      await _getAddressesCollection(currentUserId).add(address.toFireStore());
    } catch (e) {
      throw Exception('Failed to save address: $e');
    }
  }

  Stream<List<AddressModel>> getAddressesForCurrentUser() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _getAddressesCollection(currentUserId)
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
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      throw Exception('User not  authenticated');
    }
    if (address.id == null) {
      throw Exception('Address ID is required for update');
    }
    try {
      await _getAddressesCollection(
        currentUserId,
      ).doc(address.id).update(address.toFireStore());
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  Future<void> deleteAddress({required String addressId}) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _getAddressesCollection(currentUserId).doc(addressId).delete();
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  Future<void> selectAddress(String addressId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();
    final collectionRef = _getAddressesCollection(currentUserId);
    final snapshot = await collectionRef.get();

    for (var doc in snapshot.docs) {
      if (doc.id == addressId) {
        batch.update(doc.reference, {'isSelected': true});
      } else {
        // Reset others to false
        batch.update(doc.reference, {'isSelected': false});
      }
    }
    await batch.commit();
  }
}



