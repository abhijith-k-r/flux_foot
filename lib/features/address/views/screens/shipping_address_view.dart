import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_bloc.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_state.dart';
import 'package:fluxfoot_user/features/address/views/screens/add_address_view.dart';
import 'package:fluxfoot_user/features/address/views/widgets/shippingaddress_addresscard_widget.dart';

class ShippingAddressView extends StatefulWidget {
  const ShippingAddressView({super.key});

  @override
  State<ShippingAddressView> createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {
  List<AddressModel> _lastLoadedAddresses = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: customText(
          size * 0.065,
          'Shipping Addresses',
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: size * 0.04,
          vertical: size * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ! Address Adding Button
            CustomButton(
              ontap: () {
                fadePush(context, AddAddressViewBody());
              },
              backColor: AppColors.bgOrange,
              text: 'Add New Address',
              textColor: AppColors.textBlack,
              fontSize: size * 0.05,
              widget: Icon(CupertinoIcons.add_circled),
            ),
            SizedBox(height: size * 0.02),
            customText(
              size * 0.05,
              'Mange Adress',
              fontWeight: FontWeight.bold,
            ),

            Expanded(
              child: BlocConsumer<ShippingAddressBloc, ShippingAddressState>(
                listener: (context, state) {
                  if (state is ShippingAddressFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AddAddressInitial) {
                    // ! Load addresses when the view is first shown
                    context.read<ShippingAddressBloc>().add(
                      LoadShippingAddresses(),
                    );
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ShippingAddressLoading) {
                    // ! Show last loaded addresses if available, otherwise show loading
                    if (_lastLoadedAddresses.isNotEmpty) {
                      return ListView.builder(
                        itemCount: _lastLoadedAddresses.length,
                        itemBuilder: (context, index) {
                          final address = _lastLoadedAddresses[index];
                          return AddressCard(size: size, address: address);
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ShippingAddressFailure) {
                    // ! Show last loaded addresses if available, otherwise show error
                    if (_lastLoadedAddresses.isNotEmpty) {
                      return ListView.builder(
                        itemCount: _lastLoadedAddresses.length,
                        itemBuilder: (context, index) {
                          final address = _lastLoadedAddresses[index];
                          return AddressCard(size: size, address: address);
                        },
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${state.error}'),
                          SizedBox(height: size * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ShippingAddressBloc>().add(
                                LoadShippingAddresses(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ShippingAddressListLoaded) {
                    _lastLoadedAddresses = state.addresses;
                    if (state.addresses.isEmpty) {
                      return const Center(
                        child: Text('No saved addresses yet. Add one!'),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        return AddressCard(size: size, address: address);
                      },
                    );
                  }

                  // ! Handle AddAddressSuccess - show last loaded addresses
                  if (state is AddAddressSuccess) {
                    if (_lastLoadedAddresses.isNotEmpty) {
                      return ListView.builder(
                        itemCount: _lastLoadedAddresses.length,
                        itemBuilder: (context, index) {
                          final address = _lastLoadedAddresses[index];
                          return AddressCard(size: size, address: address);
                        },
                      );
                    }
                    return const Center(
                      child: Text('No saved addresses yet. Add one!'),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

