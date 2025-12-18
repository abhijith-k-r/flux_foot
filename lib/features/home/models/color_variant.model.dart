import 'package:fluxfoot_user/features/home/models/size_quantity_model.dart';

class ColorvariantModel {
  String colorName;
  String colorCode;
  List<String> imageUrls;
  List<SizeQuantityVariant> sizes;

  ColorvariantModel({
    required this.colorName,
    this.colorCode = '#000000',
    this.imageUrls = const [],
    this.sizes = const [],
  });

  ColorvariantModel copyWith({
    String? colorName,
    String? colorCode,
    List<String>? imageUrls,
    List<SizeQuantityVariant>? sizes,
  }) {
    return ColorvariantModel(
      colorName: colorName ?? this.colorName,
      colorCode: colorCode ?? this.colorCode,
      imageUrls: imageUrls ?? this.imageUrls,
      sizes: sizes ?? this.sizes,
    );
  }

  Map<String, dynamic> toMap() => {
    'colorName': colorName,
    'colorCode': colorCode,
    'imageUrls': imageUrls,
    'sizes': sizes.map((s) => s.toMap()).toList(),
  };

  factory ColorvariantModel.fromMap(Map<String, dynamic> map) {
    return ColorvariantModel(
      colorName: map['colorName'] ?? '',
      colorCode: map['colorCode'] ?? '#000000',
      imageUrls:
          (map['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      sizes:
          (map['sizes'] as List<dynamic>?)
              ?.map(
                (e) => SizeQuantityVariant.fromMap(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          [],
    );
  }
}
