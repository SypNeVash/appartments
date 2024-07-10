import 'package:flutter/material.dart';

InputDecoration decorationForTextFormField(String textForForm, {Widget? icon}) {
  return InputDecoration(
      isDense: true,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.white,
      focusedBorder: outlineMainInputFocusedBorder,
      enabledBorder: outlineMainInputFocusedBorder,
      errorBorder: outlineMainInputFocusedBorder,
      focusedErrorBorder: outlineMainInputFocusedBorder,
      contentPadding:
          const EdgeInsets.only(top: 24, bottom: 5, left: 15, right: 13),
      hintStyle: const TextStyle(
          color: Color.fromARGB(255, 112, 112, 112),
          fontSize: 14,
          fontWeight: FontWeight.w600),
      border: outlineMainInputFocusedBorder,
      hintText: textForForm);
}

final outlineMainInputFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide:
      const BorderSide(color: Color.fromARGB(255, 171, 107, 255), width: 1.5),
);

InputDecoration nonActiveDecorationTextField(String? textForForm,
    {Widget? icon}) {
  return InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(255, 235, 232, 232),
      focusedBorder: nonActiveOutlineMainBorder,
      enabledBorder: nonActiveOutlineMainBorder,
      errorBorder: nonActiveOutlineMainBorder,
      focusedErrorBorder: nonActiveOutlineMainBorder,
      hintStyle: const TextStyle(
          color: Color.fromARGB(255, 31, 31, 31),
          fontSize: 14,
          fontWeight: FontWeight.w600),
      border: nonActiveOutlineMainBorder,
      hintText: textForForm);
}

final nonActiveOutlineMainBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide:
      const BorderSide(color: Color.fromARGB(255, 235, 232, 232), width: 1.5),
);
