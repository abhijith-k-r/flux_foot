import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileImagePicker extends StatelessWidget {
  final double size;
  final String? networkImageUrl;
  final XFile? selectedImage;
  final bool isUpdating;
  final Function(XFile) onImageSelected;
  final VoidCallback onRemoveImage;

  const EditProfileImagePicker({
    super.key,
    required this.size,
    required this.networkImageUrl,
    required this.selectedImage,
    required this.isUpdating,
    required this.onImageSelected,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (selectedImage != null) {
      imageProvider = FileImage(File(selectedImage!.path));
    } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(networkImageUrl!);
    } else {
      imageProvider = null;
    }

    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: size * 0.15,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(Icons.person, size: size * 0.15)
                : null,
          ),
          if (!isUpdating)
            InkWell(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  onImageSelected(image);
                }
              },
              child: CircleAvatar(
                radius: size * 0.05,
                backgroundColor: AppColors.bgOrange,
                child: Icon(
                  Icons.camera_alt,
                  size: size * 0.05,
                  color: AppColors.iconWhite,
                ),
              ),
            ),
          // ! Remove Image Button
          if (!isUpdating &&
              (selectedImage != null ||
                  (networkImageUrl != null && networkImageUrl!.isNotEmpty)))
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: onRemoveImage,
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  size: size * 0.05,
                  color: AppColors.iconRed,
                ),
              ),
            ),
          if (isUpdating)
            Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.bgOrange),
              ),
            ),
        ],
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (label.contains('Name') && (value == null || value.isEmpty)) {
          return 'Name cannot be empty';
        }
        return null;
      },
    );
  }
}
