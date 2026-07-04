import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Color? color;
  final bool isActive;
  final IconData? activeIcon;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    this.icon,
    this.text,
    this.color,
    this.isActive = false,
    this.activeIcon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? const Color(0xFFE61E62);
    final effectiveColor = onPressed != null ? themeColor : Colors.grey.shade400;

    return Padding(
      padding: EdgeInsets.zero,
      child: IconButton(
        icon: icon != null
            ? Icon(isActive && activeIcon != null ? activeIcon! : icon, size: 15, color: effectiveColor)
            : Text(text ?? "", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: effectiveColor)),
        onPressed: onPressed,
        padding: const EdgeInsets.all(0),
        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      ),
    );
  }
}
