import 'package:flutter/material.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/views/widgets/addaddress_textfor_widget.dart';
import 'package:fluxfoot_user/features/address/views/widgets/addaddress_edit_addbutton_widget.dart';

// ! All Text Form and Save & undate Butoon
Widget buildTextFormasInsideColum(
  double size,
  bool isEditing,
  TextEditingController nameController,
  TextEditingController labelController,
  TextEditingController phoneController,
  TextEditingController pinController,
  TextEditingController districtController,
  TextEditingController stateController,
  TextEditingController cityController,
  TextEditingController houseController,
  TextEditingController roadController,
  GlobalKey<FormState> formKey,
  AddressModel? addressToEdit,
) {
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

      // ! User Address Label Text Form Field
      buildTextField(
        size: size,
        label: 'LABEL',
        hint: 'HOUSE,OFFICE*',
        controller: labelController,
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
        addressToEdit,
        nameController,
        phoneController,
        pinController,
        districtController,
        stateController,
        cityController,
        houseController,
        roadController,
        labelController,
      ),
    ],
  );
}
