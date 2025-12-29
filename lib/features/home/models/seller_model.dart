class SellerModel {
  final String uid;
  final String name;
  final String storeName;
  final String businessName;
  final String? logoUrl;
  final String email;

  SellerModel({
    required this.uid,
    required this.name,
    required this.storeName,
    required this.businessName,
    this.logoUrl,
    required this.email,
  });

  factory SellerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SellerModel(
      uid: id,
      name: data['name'] ?? '',
      storeName: data['store name'] ?? '',
      businessName: data['businessName'] ?? 'Unknown Store',
      logoUrl: data['logoUrl'],
      email: data['email'] ?? '',
    );
  }
}
