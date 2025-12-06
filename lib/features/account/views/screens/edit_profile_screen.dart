import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_snackbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/account/view_model/bloc/profile_bloc.dart';
import 'package:fluxfoot_user/features/account/views/widgets/edit_profile_components.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  bool _isControllerInitialized = false;
  XFile? _selectedImage;
  bool _removeImage = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    dobController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      context.read<ProfileBloc>().add(ProfileLoadRequested());
      _isControllerInitialized = true;
    }
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: Center(
          child: customText(
            size * 0.065,
            'Edit Profile',
            fontWeight: FontWeight.w600,
          ),
        ),
        action: [SizedBox(width: size * 0.2)],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.error && state.error != null) {
            customSnackBar(context, state.error!, Icons.error, AppColors.bgRed);
          }
          if (state.status == ProfileStatus.loaded && state.user != null) {
            final user = state.user!;
            if (nameController.text.isEmpty && !_isControllerInitialized) {}
            if (nameController.text != user.name &&
                nameController.text.isEmpty) {
              nameController.text = user.name;
            }
            if (phoneController.text != user.phone &&
                phoneController.text.isEmpty) {
              phoneController.text = user.phone;
            }
            if (dobController.text != (user.dob ?? '') &&
                dobController.text.isEmpty) {
              dobController.text = user.dob ?? '';
            }
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = state.user;
          if (user == null) {
            return const Center(child: Text("Error: User data not available."));
          }

          if (nameController.text.isEmpty) nameController.text = user.name;
          if (phoneController.text.isEmpty) phoneController.text = user.phone;
          if (dobController.text.isEmpty) dobController.text = user.dob ?? '';

          return SingleChildScrollView(
            padding: EdgeInsets.all(size * 0.05),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  EditProfileImagePicker(
                    size: size,
                    networkImageUrl: _removeImage ? null : user.imageUrl,
                    selectedImage: _selectedImage,
                    isUpdating: state.status == ProfileStatus.updating,
                    onImageSelected: (image) => setState(() {
                      _selectedImage = image;
                      _removeImage = false;
                    }),
                    onRemoveImage: () => setState(() {
                      _selectedImage = null;
                      _removeImage = true;
                    }),
                  ),
                  SizedBox(height: size * 0.1),
                  EditProfileTextField(
                    controller: nameController,
                    label: 'Name',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: size * 0.05),
                  EditProfileTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: size * 0.05),
                  EditProfileTextField(
                    controller: dobController,
                    label: 'Date of Birth (DD/MM/YYYY)',
                    icon: Icons.cake_outlined,
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: size * 0.1),
                  CustomButton(
                    backColor: AppColors.sucessGreen,
                    widget: state.status == ProfileStatus.updating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Icon(Icons.save, color: AppColors.iconWhite),
                    text: state.status == ProfileStatus.updating
                        ? 'SAVING...'
                        : 'Save Changes',
                    fontSize: size * 0.05,
                    spacing: size * 0.05,
                    fontWeight: FontWeight.bold,
                    showTextAndWidget: true,
                    ontap: state.status == ProfileStatus.updating
                        ? () {}
                        : () {
                            if (formKey.currentState!.validate()) {
                              context.read<ProfileBloc>().add(
                                ProfileUpdateRequested(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  dob: dobController.text,
                                  imageFile: _selectedImage,
                                  removeImage: _removeImage,
                                ),
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
