// The Widget remains the same, but we use context.read<CarouselCubit>()
// in the PageController listener to update the index.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/view_model/carousel_cubit/carousal_cubit.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_transparant_screen.dart';

class ProductImageFlipCarousel extends StatefulWidget {
  final List<String> images;
  final double height;

  const ProductImageFlipCarousel({ 
    super.key,
    required this.images,
    required this.height,
  });

  @override
  State<ProductImageFlipCarousel> createState() =>
      _ProductImageFlipCarouselState();
}

class _ProductImageFlipCarouselState extends State<ProductImageFlipCarousel> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });

      // 1. Dispatch the currently centered index to the Cubit
      // Check if the page is close to an integer (i.e., a card is centered)
      final int centeredIndex = (_pageController.page?.round() ?? 0).clamp(
        0,
        widget.images.length - 1,
      );

      // Use context.read to access the Cubit instance provided higher up the tree
      context.read<CarouselCubit>().updateIndex(centeredIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // The _buildProductCard method remains UNCHANGED as it manages local animation
  Widget _buildProductCard(BuildContext context, int index) {
    // ... (rest of the _buildProductCard implementation remains exactly the same)
    double value = 0.0;
    if (_pageController.position.haveDimensions) {
      value = index - _currentPage;
      value = value.clamp(-1.0, 1.0);
    }
    final double rotation = value * pi / 4.0;

    return Center(
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          final Matrix4 transform = Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(rotation);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              height: widget.height,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () => navigateToTransparentScreen(
                      context,
                      widget.images[index],
                    ),
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return _buildProductCard(context, index);
      },
    );
  }
}

// ! current Index of Carousel Image.
Widget buildCarouselIndex(List<String> currentImages) {
  return BlocBuilder<CarouselCubit, int>(
    builder: (context, currentIndex) {
      return customText(
        16,
        ' ${currentIndex + 1} / ${currentImages.length}',
        fontWeight: FontWeight.bold,
      );
    },
  );
}
