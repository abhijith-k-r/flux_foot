import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class ProductView extends StatelessWidget {
  final String productName;
  final List<String> images;
  final String regularPrice;
  final String salePrice;
  final String description;
  const ProductView({
    super.key,
    required this.images,
    required this.productName,
    required this.regularPrice,
    required this.salePrice,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        action: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: size * 0.02,
            children: [
              Center(
                child: SizedBox(
                  height: size * 0.8,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Image.network(images[i]),
                      );
                    },
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: size * 0.02,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.btnPink,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    width: size * 0.15,
                    height: size * 0.15,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.btnPink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: size * 0.15,
                    height: size * 0.15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.btnPink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: size * 0.15,
                    height: size * 0.15,
                  ),
                ],
              ),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(size * 0.03),
                  child: Column(
                    spacing: size * 0.02,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            16,
                            productName,
                            fontWeight: FontWeight.w600,
                          ),
                          Row(
                            spacing: size * 0.02,
                            children: [
                              customText(
                                15,
                                '₹ $salePrice/-',
                                fontWeight: FontWeight.w600,
                              ),
                              customText(
                                10,
                                '₹$regularPrice/-',
                                textDecoration: TextDecoration.lineThrough,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // ! Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: size * 0.02,
                            children: [
                              Icon(
                                CupertinoIcons.star_fill,
                                size: size * 0.05,
                                color: AppColors.iconOrangeAccent,
                              ),
                              customText(
                                14,
                                '4.1',
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: BoxBorder.all(
                                color: AppColors.outLineOrang,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: size * 0.05,
                                right: size * 0.05,
                              ),
                              child: customText(
                                15,
                                'Red',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ! Product Sizes
                      Row(
                        children: [
                          customText(16, 'Size: ', fontWeight: FontWeight.w600),
                          SizedBox(
                            width: size * 0.75,
                            height: size * 0.06,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: size * 0.01,
                                    right: size * 0.01,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: index % 2 != 0
                                          ? AppColors.bgOrange
                                          : AppColors.scaffBg,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: size * 0.01,
                                        right: size * 0.01,
                                      ),
                                      child: customText(15, "S- small"),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              customText(16, 'Description', fontWeight: FontWeight.w600),
              // ! Custom Ream More Text
              customReadmoreText(description),
              SizedBox(height: size * 1),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: size * 0.02,
        children: [
          CustomButton(
            width: 180,
            backColor: AppColors.bgWhite,
            textColor: AppColors.textBlack,
            widget: Icon(CupertinoIcons.cart),
            text: 'Add to Cart',
            fontSize: size * 0.04,
            fontWeight: FontWeight.bold,
            ontap: () {},
          ),
          CustomButton(
            width: 180,
            backColor: AppColors.bgOrange,
            textColor: AppColors.textBlack,
            widget: Icon(Icons.price_change),
            text: 'Buy now',
            fontSize: size * 0.04,
            fontWeight: FontWeight.bold,
            ontap: () {},
          ),
        ],
      ),
    );
  }

   
}




// ! Custom READ MORE TEXT

customReadmoreText(String description) {
  return ReadMoreText(
    description,
    trimLines: 5,
    colorClickableText: AppColors.textBlack,
    trimMode: TrimMode.Line,
    trimCollapsedText: '...Read more',
    trimExpandedText: ' Less',
    style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500),
    moreStyle: GoogleFonts.openSans(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.textBlack,
    ),
    lessStyle: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.textBlack,
    ),
  );
}
