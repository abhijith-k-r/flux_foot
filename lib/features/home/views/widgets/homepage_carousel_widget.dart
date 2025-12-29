import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/core/widgets/shimmer_widgets.dart';
import 'package:fluxfoot_user/features/home/view_model/carousel_bloc/carousel_bloc.dart';

class UserHomePageCarousel extends StatelessWidget {
  const UserHomePageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => CarouselBloc()..add(FetchCarouselData()), 
      child: BlocBuilder<CarouselBloc, UserCarouselState>(
        builder: (context, state) {
          if (state is CarouselLoading) {
            return SizedBox(
              height: 200,
              child: ShimmerPlaceholder(
                width: size * 0.99,
                height: size * 0.4,
                borderRadius: 25,
              ),
            );
          } else if (state is CarouselError) {
            return Center(child: Text(state.message));
          } else if (state is CarouselLoaded) {
            final data = state.data;

            return CarouselSlider(
              key: ValueKey(
                '${data.autoRotate}_${data.duration}_${data.direction}',
              ),
              options: CarouselOptions(
                // Logic from Admin Settings:
                autoPlay: data.autoRotate,
                autoPlayInterval: Duration(seconds: data.duration),
                scrollDirection: data.direction == 'horizontal'
                    ? Axis.horizontal
                    : Axis.vertical,

                // Layout Settings:
                viewportFraction: 1,
                aspectRatio: 16 / 9,
                enlargeCenterPage: false,
              ),
              items: data.slides.map((slide) {
                return Stack(
                  children: [
                    // The Image
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          slide.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return ShimmerPlaceholder(
                              width: size * 0.99,
                              height: size * 0.4,
                              borderRadius: 25,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: size * 0.99,
                              height: size * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      //  Image.network(slide.imageUrl, fit: BoxFit.cover),
                    ),
                    // The Overlay Text added by Admin
                    if (slide.text.isNotEmpty)
                      Positioned(
                        bottom: 30,
                        left: 20,
                        right: 20,
                        child: customText(
                          appColor: AppColors.textWite,
                          size * 0.07,
                          slide.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                );
              }).toList(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
