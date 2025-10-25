// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';

// !Show logout dialog
Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => LogoutDialog(),
  );
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 384),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF262626) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 44, 24, 24),
              child: Column(
                children: [
                  Text(
                    'Logging out?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will be returned to the login screen',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                 _DialogButton(
                    text: 'Yes',
                    color: Colors.red,
                    isBold: true,
                    onTap: () => Navigator.pop(
                      context,
                      true,
                    ), // Immediately close with true
                  ),
                  Container(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  Container(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  _DialogButton(
                    text: 'No',
                    color: isDark
                        ? const Color(0xFFD1D5DB)
                        : const Color(0xFF374151),
                    isBold: false,
                    onTap: () => Navigator.pop(context, false),
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

class _DialogButton extends StatefulWidget {
  final String text;
  final Color color;
  final bool isBold;
  final Function()? onTap;

  const _DialogButton({
    required this.text,
    required this.color,
    required this.isBold,
    required this.onTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: isHovered
              ? (isDark
                    ? const Color(0xFF1F2937).withOpacity(0.5)
                    : const Color(0xFFF9FAFB))
              : Colors.transparent,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: widget.isBold ? FontWeight.bold : FontWeight.w500,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
