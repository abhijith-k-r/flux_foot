// ! Helper Widget: Info Card (Address)
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

Widget buildInfoCard({
  required bool isDark,
  required IconData icon,
  required String title,
  required String content,
  required VoidCallback onEdit,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.bgWhite,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.bgGrey.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onEdit,
              child: Row(
                children: [
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bgOrange,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.iconOrangeAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
    ),
  );
}
