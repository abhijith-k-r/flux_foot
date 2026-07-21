class SizeQuantityVariant {
  String size;
  int quantity;

  SizeQuantityVariant({required this.size, required this.quantity});

  Map<String, dynamic> toMap() => {'size': size, 'quantity': quantity};

  factory SizeQuantityVariant.fromMap(Map<String, dynamic> map) {
    return SizeQuantityVariant(
      size: map['size'] ?? '',
      quantity: int.tryParse(map['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}
