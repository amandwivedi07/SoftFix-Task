import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/colors.dart';

class Button extends StatelessWidget {
  final String label;
  final IconData? icon;
  final void Function() onPressed;
  final Color? backgroundColor, textColor, disabledColor;
  final double? width, height;
  final bool? disabled;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final bool? italic;

  const Button({
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.disabled,
    this.fontSize,
    this.padding,
    this.disabledColor,
    this.italic,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor:
              backgroundColor == null ? kPrimaryColor : backgroundColor,
          foregroundColor: textColor == null ? Colors.white : textColor,
        ),
        icon: icon == null ? SizedBox() : Icon(icon, size: 20),
        onPressed: disabled != null && disabled! ? null : onPressed,
        label: Text(
          label,
          style: TextStyle(
              fontSize: fontSize ?? 16,
              fontStyle: italic != null ? FontStyle.italic : null),
        ),
      ),
    );
  }
}
