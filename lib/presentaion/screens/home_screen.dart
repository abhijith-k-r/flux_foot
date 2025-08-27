// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/presentaion/screens/login_screen.dart';
import 'package:fluxfoot_user/presentaion/widgets/homescreen_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: CustomAppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: width * 0.01), // small left space
          child: SizedBox(
            width: 70,
            height: 60,
            child: ShakeX(
              delay: Duration(milliseconds: 900),
              duration: Duration(milliseconds: 900),
              child: Image.asset(
                'Flux_Foot/assets/images/splash/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        action: [
          IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.bell)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSearchBar(width: width, height: height),
              SizedBox(height: height * 0.02),
              Container(
                width: width * 0.999,
                height: height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(25),
                  child: Image.network(
                    'https://i.pinimg.com/1200x/ca/e7/0d/cae70d9b1688cc21c1d7c2d07d0d808f.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              AuthCheckBox(
                mainAxis: MainAxisAlignment.spaceBetween,
                prefText: 'Search by brands',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                sufWidget: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: GoogleFonts.openSans(color: Colors.black),
                  ),
                ),
              ),

              // ! Search By Brands
              Row(
                spacing: width * 0.04,
                children: [
                  Container(
                    width: width * 0.15,
                    height: height * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'Flux_Foot/assets/images/icons/Puma.png',
                    ),
                  ),
                  Container(
                    width: width * 0.15,
                    height: height * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'Flux_Foot/assets/images/icons/Adiddas.png',
                    ),
                  ),
                  Container(
                    width: width * 0.15,
                    height: height * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'Flux_Foot/assets/images/icons/Nike.png',
                    ),
                  ),
                  Container(
                    width: width * 0.15,
                    height: height * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'Flux_Foot/assets/images/icons/Fila.png',
                    ),
                  ),
                  Container(
                    width: width * 0.15,
                    height: height * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'Flux_Foot/assets/images/icons/Rebook.png',
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              AuthCheckBox(
                mainAxis: MainAxisAlignment.spaceBetween,
                prefText: 'Featured Products',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                sufWidget: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: GoogleFonts.openSans(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.9, // Adjust this height as needed
                child: GridView.builder(
                  shrinkWrap: true, // This is fine here
                  physics:
                      NeverScrollableScrollPhysics(), // Allow grid scrolling
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      productName: getProductName(index),
                      rating: getRating(index),
                      price: getPrice(index),
                      originalPrice: getOriginalPrice(index),
                      color: getProductColor(index),
                    );
                  },
                ),
              ),
              SizedBox(height: width * 005),
            ],
          ),
        ),
      ),
    );
  }
}

// ! Custom Search BAr
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: width * 0.03,
      children: [
        Container(
          width: width * 0.79,
          height: height * 0.053,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              hintStyle: GoogleFonts.openSans(),
            ),
          ),
        ),

        Container(
          width: width * 0.099,
          height: height * 0.053,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.qr_code_scanner_sharp),
          ),
        ),
      ],
    );
  }
}
