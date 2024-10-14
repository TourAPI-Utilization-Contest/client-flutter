import 'package:flutter/material.dart';
import 'package:tradule/common/color.dart';

import 'my_text_style.dart';

class LoginTextFormField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final String? initialValue;
  final TextEditingController? controller;
  final GlobalKey<FormFieldState> formFieldKey;
  final FocusNode focusNode;
  final bool autofocus;
  // final bool validateFlag;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final String? helperText;

  const LoginTextFormField({
    required this.hintText,
    required this.isPassword,
    required this.formFieldKey,
    required this.focusNode,
    this.autofocus = false,
    // required this.validateFlag,
    this.onChanged,
    this.onSubmitted,
    required this.validator,
    this.initialValue,
    this.controller,
    this.helperText,
    super.key,
  });

  @override
  State<LoginTextFormField> createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formFieldKey,
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : TextInputType.text,
      initialValue: widget.initialValue,
      controller: widget.controller,
      obscureText: widget.isPassword,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        helperText: widget.helperText,
        helperStyle: myTextStyle(
          // color: cGray3,
          fontSize: 12,
          fontWeight: FontWeight.w200,
          letterSpacing: 0.4,
          height: 1.3,
        ),
        hintText: widget.hintText,
        hintStyle: myTextStyle(
          color: cGray,
          fontWeight: FontWeight.w200,
          fontSize: 16,
        ),
        errorStyle: myTextStyle(
          color: const Color(0xFFBA1A1A),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.3,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17.0,
          horizontal: 25.0,
        ),
      ),
      validator: widget.validator,
    );
  }
}
