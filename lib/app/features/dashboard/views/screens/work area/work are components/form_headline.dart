import 'package:flutter/material.dart';

class FormHeadline extends StatelessWidget {
  final String headLine;
  final String subLine;
  const FormHeadline({required this.headLine, required this.subLine, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          headLine,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          subLine,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
