import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:provider/provider.dart';

import '../home/controller/product_controller.dart';

class MyFormField extends StatelessWidget {
  bool? enabled = true;

  TextEditingController? controller;
  String? label;
  final String? hintText;
  TextInputType? type;
  final IconData? data;
  final IconData? suffixIconData;
  final bool? obscureText;
  int? maxLines;
  String? Function(String?)? validator;
  MyFormField({
    Key? key,
    this.enabled,
    this.controller,
    this.label,
    this.hintText,
    this.type,
    this.data,
    this.maxLines,
    this.validator,
    this.suffixIconData,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProductProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        obscureText: obscureText ?? false,
        enabled: enabled,
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: darkGreenColor,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              model.isVisible = !model.isVisible;
            },
            child: Icon(
              suffixIconData,
              size: 18,
              color: darkGreenColor,
            ),
          ),
          focusColor: Theme.of(context).primaryColor,
          labelText: label,
          hintText: hintText,
          // prefixText: controller == phoneController ? '+91' : null
        ),
        validator: validator,
        onChanged: (value) {},
      ),
    );
  }
}
