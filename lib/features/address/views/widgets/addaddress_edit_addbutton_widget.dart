import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_bloc.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_state.dart';

// ! Address Add Edit Helper Button
Widget buildAddressAddEditButton(
  bool isEditing,
  double size,
  GlobalKey<FormState> formKey,
  AddressModel? addressToEdit,
  TextEditingController nameController,
  TextEditingController phoneController,
  TextEditingController pinController,
  TextEditingController districtController,
  TextEditingController stateController,
  TextEditingController cityController,
  TextEditingController houseController,
  TextEditingController roadController,
) {
  return BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
    builder: (context, state) {
      final bool isLoading = state is ShippingAddressLoading;
      return CustomButton(
        backColor: AppColors.bgOrange,
        // Disable button if loading, otherwise call _saveAddress
        ontap: isLoading
            ? null
            : () => saveAddress(
                context,
                formKey,
                addressToEdit,
                nameController,
                phoneController,
                pinController,
                districtController,
                stateController,
                cityController,
                houseController,
                roadController,
              ),
        widget: isLoading
            ? CupertinoActivityIndicator(color: AppColors.textBlack)
            : Icon(
                isEditing
                    ? CupertinoIcons.check_mark_circled
                    : CupertinoIcons.cloud_upload,
              ),
        text: isLoading
            ? (isEditing ? 'Updating...' : 'Saving...')
            : (isEditing ? 'Update Address' : 'Save Address'),
        textColor: AppColors.textBlack,
        fontSize: size * 0.05,
        fontWeight: FontWeight.bold,
      );
    },
  );
}



// ! Save Address Helper Function
void saveAddress(
  BuildContext context,
  GlobalKey<FormState> formKey,
  AddressModel? addressToEdit,
  TextEditingController nameController,
  TextEditingController phoneController,
  TextEditingController pinController,
  TextEditingController districtController,
  TextEditingController stateController,
  TextEditingController cityController,
  TextEditingController houseController,
  TextEditingController roadController,
) {
  if (formKey.currentState!.validate()) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not authenticated.')),
      );
      return;
    }

    final address = AddressModel(
      id: addressToEdit?.id,
      fullName: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      pinCode: pinController.text.trim(),
      district: districtController.text.trim(),
      state: stateController.text.trim(),
      city: cityController.text.trim(),
      houseNo: houseController.text.trim(),
      roadAreaColony: roadController.text.trim(),
      userId: currentUserId,
      createdAt: addressToEdit?.createdAt ?? DateTime.now(),
    );

    if (addressToEdit != null) {
      context.read<ShippingAddressBloc>().add(UpdateAddress(address: address));
    } else {
      context.read<ShippingAddressBloc>().add(SaveNewAddress(address: address));
    }
  }
}
