// ignore_for_file: use_build_context_synchronously

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
import 'package:fluxfoot_user/features/address/views/widgets/shippingaddress_edit_delete_widget.dart';

class ShippingAddressView extends StatefulWidget {
  const ShippingAddressView({super.key});

  @override
  State<ShippingAddressView> createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {
  List<AddressModel> _lastLoadedAddresses = [];
  String? _selectedAddressId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: const BackButton(),
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
              'Saved Addresses',
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
                      return buildAddressList();
                    }
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ShippingAddressFailure) {
                    // ! Show last loaded addresses if available, otherwise show error
                    if (_lastLoadedAddresses.isNotEmpty) {
                      return buildAddressList();
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
                    return buildAddressList();
                  }

                  // ! Handle AddAddressSuccess - show last loaded addresses
                  if (state is AddAddressSuccess) {
                    if (_lastLoadedAddresses.isNotEmpty) {
                      return buildAddressList();
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

  // ! Helper Fucntion For Show Show edit delete menu and Address Card.
  Widget buildAddressList() {
    final size = MediaQuery.of(context).size.width;

    if (_selectedAddressId == null && _lastLoadedAddresses.isNotEmpty) {
      try {
        final selected = _lastLoadedAddresses.firstWhere((a) => a.isSelected);
        _selectedAddressId = selected.id;
      } catch (e) {
        // None selected
      }
    }

    return ListView.builder(
      itemCount: _lastLoadedAddresses.length,
      itemBuilder: (context, index) {
        final address = _lastLoadedAddresses[index];
                final isSelected =
            (_selectedAddressId == address.id) ||
            (address.isSelected && _selectedAddressId == null);

        return SelectableAddressCard(
          size: size,
          address: address,
          isSelected: isSelected,
          onSelect: () {
            setState(() {
              _selectedAddressId = address.id;
            });
                        context.read<ShippingAddressBloc>().add(
              SelectAddressEvent(address.id!),
            );

             Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) Navigator.pop(context);
            });

          },
          onEdit: () => showEditDeleteMenu(context, address),
        );
      },
    );
  }
}
