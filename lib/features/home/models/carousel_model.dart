class CarouselData {
  final List<CarouselSlide> slides;
  final int duration;
  final String direction;
  final bool autoRotate;

  CarouselData({
    required this.slides,
    required this.duration,
    required this.direction,
    required this.autoRotate,
  });

  factory CarouselData.fromFirestore(Map<String, dynamic> doc) {
    final settings = doc['settings'] as Map<String, dynamic>?;
    return CarouselData(
      slides: (doc['slides'] as List? ?? [])
          .map((item) => CarouselSlide.fromMap(item))
          .toList(),
      duration: settings?['rotationInterval'] ?? doc['rotationInterval'] ?? 5,
      direction: settings?['scrollDirection'] ?? doc['scrollDirection'] ?? 'horizontal',
      autoRotate: settings?['autoRotate'] ?? doc['autoRotate'] ?? true,
    );
  }
}

class CarouselSlide {
  final String imageUrl;
  final String text;

  CarouselSlide({required this.imageUrl, required this.text});

  factory CarouselSlide.fromMap(Map<String, dynamic> map) {
    return CarouselSlide(
      imageUrl: map['imageUrl'] ?? '',
      text: map['text'] ?? '',
    );
  }
}
