import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

// ! Custom App_Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> action;
  const CustomAppBar({
    super.key,
    this.leading = const SizedBox.shrink(),
    this.title = const SizedBox(),
    this.action = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffBg,
      leading: leading,
      title: title,
      actions: action,
    );
  }
}
