import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';

class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double regularPrice; 
  final double salePrice; 
  final int quantity;
  final String category;
  final String brand;
  final List<String> images;
  final String status;
  final String sellerId;
  final DateTime createdAt;
  final Map<String, dynamic> dynammicSpecs;
  final List<ColorvariantModel> variants;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.regularPrice,
    required this.salePrice,
    required this.quantity,
    required this.category,
    required this.brand,
    required this.images,
    required this.status,
    required this.sellerId,
    required this.createdAt,
    this.dynammicSpecs = const {},
    this.variants = const [],
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? regularPrice,
    double? salePrice,
    int? quantity,
    String? category,
    String? brand,
    List<String>? images,
    String? status,
    String? sellerId,
    DateTime? createdAt,
    Map<String, dynamic>? dynammicSpecs,
    List<ColorvariantModel>? variants,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      images: images ?? this.images,
      status: status ?? this.status,
      sellerId: sellerId ?? this.sellerId,
      createdAt: createdAt ?? this.createdAt,
      dynammicSpecs: dynammicSpecs ?? this.dynammicSpecs,
      variants: variants ?? this.variants,
    );
  }

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    var imagesData = data['images'];
    List<String> imagesList;

    if (imagesData == null) {
      imagesList = [];
    } else if (imagesData is String) {
      imagesList = [imagesData];
    } else if (imagesData is Iterable) {
      imagesList = List<String>.from(imagesData);
    } else {
      imagesList = [];
    }
    // Read variants safely
    final variantsRaw = data['variants'] as List<dynamic>? ?? [];
    final variantsList = variantsRaw
        .map(
          (e) => ColorvariantModel.fromMap(Map<String, dynamic>.from(e as Map)),
        )
        .toList();

        // Helper function for safe number parsing
    double parsePrice(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 1; 
      return 1;
    }

    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      regularPrice: parsePrice(data['regularPrice']),
      salePrice: parsePrice(data['salePrice']),
      quantity: parseInt(data['quantity']),
      category: data['category'] ?? '',
      brand: data['brand'] ?? '',
      images: imagesList,
      status: data['status'] ?? '',
      sellerId: data['sellerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dynammicSpecs: data['dynamicSpecs'] as Map<String, dynamic>? ?? {},
      variants: variantsList,
    );
  }
}
