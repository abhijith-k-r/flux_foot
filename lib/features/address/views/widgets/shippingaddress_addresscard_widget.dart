// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/views/widgets/shippingaddress_edit_delete_widget.dart';

// ! Helper Widget to display a single address card
// class AddressCard extends StatelessWidget {
//   final double size;
//   final AddressModel address;

//   const AddressCard({super.key, required this.size, required this.address});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: size * 0.02),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: customText(
//                     size * 0.05,
//                     address.fullName,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => showEditDeleteMenu(context, address),
//                   icon: const Icon(CupertinoIcons.ellipsis_vertical),
//                 ),
//               ],
//             ),

//             customText(
//               size * 0.04,
//               '${address.houseNo}, ${address.roadAreaColony}',
//               fontWeight: FontWeight.w500,
//             ),

//             customText(
//               size * 0.04,
//               '${address.city}, ${address.district}, ${address.state} - ${address.pinCode}',
//               fontWeight: FontWeight.w500,
//             ),

//             SizedBox(height: size * 0.02),

//             // ! Phone Number
//             customText(
//               size * 0.04,
//               'Phone : ${address.phoneNumber}',
//               fontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ! New Selectable Address Card
class SelectableAddressCard extends StatelessWidget {
  final double size;
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;

  const SelectableAddressCard({
    super.key,
    required this.size,
    required this.address,
    required this.isSelected,
    required this.onSelect,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.outLineOrang;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.only(bottom: size * 0.03),
        padding: EdgeInsets.all(size * 0.04),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(size * 0.03),
          border: Border.all(
            color: isSelected ? primaryColor : AppColors.bgWhite,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            else
              BoxShadow(
                color: AppColors.bgBlack.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ! Radio Button
            Container(
              margin: EdgeInsets.only(top: size * 0.005),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? primaryColor
                    // : isDark
                    // ? const Color(0xFF4A3B2F)
                    : AppColors.iconOrangeAccent,
                size: size * 0.055,
              ),
            ),
            SizedBox(width: size * 0.04),

            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label and Edit Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        address.label,
                        style: TextStyle(
                          fontSize: size * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: onEdit,
                        child: Icon(
                          Icons.edit_outlined,
                          size: size * 0.045,
                          color:
                              //  isDark
                              //     ?
                              //     const Color(0xFFCBB29E)
                              //     :
                              const Color(0xFF9A734C),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size * 0.01),

                  // Full Name
                  Text(
                    address.fullName,
                    style: TextStyle(
                      fontSize: size * 0.04,
                      fontWeight: FontWeight.w500,
                      // color: isDark
                      //     ? const Color(0xFFFCFAF8)
                      //     : const Color(0xFF1B140D),
                    ),
                  ),
                  SizedBox(height: size * 0.005),

                  // Address Lines
                  Text(
                    '${address.houseNo}, ${address.roadAreaColony}\n'
                    '${address.city}, ${address.state} ${address.pinCode}',
                    style: TextStyle(
                      fontSize: size * 0.035,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                      color: AppColors.textGrey,
                      //  isDark
                      //     ? const Color(0xFFCBB29E)
                      //     : const Color(0xFF9A734C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
