import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_bloc.dart';
import 'package:fluxfoot_user/features/address/views/screens/add_address_view.dart';

// ! Show Edit & Delete Helper Function
void showEditDeleteMenu(BuildContext context, AddressModel address) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.pencil),
            title: const Text('Edit Address'),
            onTap: () {
              Navigator.pop(context);
              fadePush(context, AddAddressViewBody(addressToEdit: address));
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.delete, color: AppColors.iconRed),
            title: const Text(
              'Delete Address',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              showDeleteConfirmation(context, address);
            },
          ),
        ],
      ),
    ),
  );
}

// ! Show Delete Confirmation Heelper Fucntion
void showDeleteConfirmation(BuildContext context, AddressModel address) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Address'),
      content: const Text('Are you sure you want to delete this address?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (address.id != null) {
              context.read<ShippingAddressBloc>().add(
                DeleteAddress(addressId: address.id!),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
