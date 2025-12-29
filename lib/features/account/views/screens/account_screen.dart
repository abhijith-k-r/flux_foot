import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/account/view_model/bloc/profile_bloc.dart';
import 'package:fluxfoot_user/features/account/views/screens/profile_screen.dart';
import 'package:fluxfoot_user/features/account/views/widgets/account_widgets.dart';
import 'package:fluxfoot_user/features/address/views/screens/shipping_address_view.dart';
import 'package:fluxfoot_user/features/order/views/screen/my_orders.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    context.read<ProfileBloc>().add(ProfileLoadRequested());

    return Scaffold(
      appBar: CustomAppBar(
        title: customText(
          size,
          'Account',
          style: GoogleFonts.rozhaOne(fontSize: size * 0.08),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final user = state.user;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: size * 0.03,
              children: [
                UserProfileImage(
                  size: size,
                  radius: size * 0.2,
                  imageUrl: user?.imageUrl, // Now correctly passing URL
                ).fadeInDownBig(),
                SizedBox(height: size * 0.1),
                // ! Personal Information
                AccountContent(
                  size: size,
                  icon: Icons.person_outline_rounded,
                  title: user?.name ?? 'Personal Information',
                  subtitle: user?.email ?? 'Update your details',
                  ontap: () {
                    fadePush(context, ProfileScreen());
                  },
                ).fadeInRight(from: 50),
                // ! Shipping Address
                AccountContent(
                  size: size,
                  icon: Icons.location_on_outlined,
                  title: 'Shipping Addresses',
                  subtitle: 'check Addresses',
                  ontap: () => fadePush(context, ShippingAddressView()),
                ).fadeInRightBig(from: 100),
                // ! Order History
                AccountContent(
                  size: size,
                  icon: Icons.card_giftcard,
                  title: 'Order History',
                  subtitle: 'view all purchases',
                  ontap: () => fadePush(context, MyOrders()),
                ).fadeInRight(from: 150),
                // ! Settings
                AccountContent(
                  size: size,
                  icon: Icons.settings, 
                  title: 'Settings',
                  subtitle: 'further details',
                  // ontap: ()=> fadePush(context, profilesc),
                ).fadeInRightBig(from: 200),
              ],
            ),
          );
        },
      ),
    );
  }
}
