import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/views/widgets/shippingaddress_edit_delete_widget.dart';

// ! Helper Widget to display a single address card
class AddressCard extends StatelessWidget {
  final double size;
  final AddressModel address;

  const AddressCard({super.key, required this.size, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: size * 0.02),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: customText(
                    size * 0.05,
                    address.fullName,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => showEditDeleteMenu(context, address),
                  icon: const Icon(CupertinoIcons.ellipsis_vertical),
                ),
              ],
            ),

            customText(
              size * 0.04,
              '${address.houseNo}, ${address.roadAreaColony}',
              fontWeight: FontWeight.w500,
            ),

            customText(
              size * 0.04,
              '${address.city}, ${address.district}, ${address.state} - ${address.pinCode}',
              fontWeight: FontWeight.w500,
            ),

            SizedBox(height: size * 0.02),

            // ! Phone Number
            customText(
              size * 0.04,
              'Phone : ${address.phoneNumber}',
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
