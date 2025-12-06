// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_snackbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_bloc.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_state.dart';
import 'package:fluxfoot_user/features/address/views/widgets/addaddress_edit_addbutton_widget.dart';
import 'package:fluxfoot_user/features/address/views/widgets/addaddress_textfor_widget.dart';

// !Internal widget to handle the UI and BLoC interaction
class AddAddressViewBody extends StatefulWidget {
  final AddressModel? addressToEdit;

  const AddAddressViewBody({super.key, this.addressToEdit});

  @override
  State<AddAddressViewBody> createState() => _AddAddressViewBodyState();
}

class _AddAddressViewBodyState extends State<AddAddressViewBody> {
  // 1. Text Controllers
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController pinController;
  late final TextEditingController districtController;
  late final TextEditingController stateController;
  late final TextEditingController cityController;
  late final TextEditingController houseController;
  late final TextEditingController roadController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing address data if editing
    nameController = TextEditingController(
      text: widget.addressToEdit?.fullName ?? '',
    );
    phoneController = TextEditingController(
      text: widget.addressToEdit?.phoneNumber ?? '',
    );
    pinController = TextEditingController(
      text: widget.addressToEdit?.pinCode ?? '',
    );
    districtController = TextEditingController(
      text: widget.addressToEdit?.district ?? '',
    );
    stateController = TextEditingController(
      text: widget.addressToEdit?.state ?? '',
    );
    cityController = TextEditingController(
      text: widget.addressToEdit?.city ?? '',
    );
    houseController = TextEditingController(
      text: widget.addressToEdit?.houseNo ?? '',
    );
    roadController = TextEditingController(
      text: widget.addressToEdit?.roadAreaColony ?? '',
    );
  }

  // Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    pinController.dispose();
    districtController.dispose();
    stateController.dispose();
    cityController.dispose();
    houseController.dispose();
    roadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final isEditing = widget.addressToEdit != null;

    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: customText(
          size * 0.065,
          isEditing ? 'Edit Address' : 'Add Address',
          fontWeight: FontWeight.w600,
        ),
      ),
      body: BlocListener<ShippingAddressBloc, ShippingAddressState>(
        listener: (context, state) {
          if (state is AddAddressSuccess) {
            customSnackBar(
              context,
              isEditing ? 'Address Updated!' : 'Address Saved!',
              Icons.abc,
              AppColors.sucessGreen,
            );

            Navigator.pop(context);
          } else if (state is ShippingAddressFailure) {
            customSnackBar(
              context,
              isEditing
                  ? 'Failed to update address: ${state.error}'
                  : 'Failed to save address: ${state.error}',
              Icons.error,
              AppColors.iconRed,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.05,
            vertical: size * 0.02,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: buildTextFormasInsideColum(size, isEditing),
            ),
          ),
        ),
      ),
    );
  }

  // ! All Text Form and Save & undate Butoon
  Widget buildTextFormasInsideColum(double size, bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ! User Name Text Form Field
        buildTextField(
          size: size,
          label: 'NAME',
          hint: 'Full name*',
          controller: nameController,
        ),
        SizedBox(height: size * 0.03),

        // ! Phone Number
        buildTextField(
          size: size,
          label: 'PHONE NUMBER',
          hint: 'phone number*',
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: size * 0.03),

        // ! Pin Code & District
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHalfTextField(
              size: size,
              label: 'PIN CODE',
              hint: 'pin code*',
              controller: pinController,
              keyboardType: TextInputType.number,
            ),
            buildHalfTextField(
              size: size,
              label: 'District',
              hint: 'district*',
              controller: districtController,
            ),
          ],
        ),
        SizedBox(height: size * 0.03),

        // ! State & City
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHalfTextField(
              size: size,
              label: 'STATE',
              hint: 'state*',
              controller: stateController,
            ),
            buildHalfTextField(
              size: size,
              label: 'CITY',
              hint: 'city*',
              controller: cityController,
            ),
          ],
        ),
        SizedBox(height: size * 0.03),

        // ! HOUSE NO, Building Name
        buildTextField(
          size: size,
          label: 'HOUSE NO, BUILDING NAME',
          hint: 'house no, building name*',
          controller: houseController,
        ),
        SizedBox(height: size * 0.03),

        // ! Road , area, colony
        buildTextField(
          size: size,
          label: 'ROAD NAME, AREA, COLONY',
          hint: 'road name, area, colony*',
          controller: roadController,
        ),
        SizedBox(height: size * 0.05),

        // ! CustomButton with BLoC State Check
        buildAddressAddEditButton(
          isEditing,
          size,
          formKey,
          widget.addressToEdit,
          nameController,
          phoneController,
          pinController,
          districtController,
          stateController,
          cityController,
          houseController,
          roadController,
        ),
      ],
    );
  }
}
