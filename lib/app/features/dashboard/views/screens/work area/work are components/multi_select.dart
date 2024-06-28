import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelector extends StatelessWidget {
  final List<MultiSelectItem<String>> items;
  final List<String> initialValue;
  final Function(List<String>) onConfirm;
  final String fieldText;
  const MultiSelector(
      {required this.items,
      required this.initialValue,
      required this.onConfirm,
      required this.fieldText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      items: items,
      initialValue: initialValue,
      title: Text(fieldText),
      selectedColor: Colors.blue,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
      ),
      buttonIcon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.blue,
      ),
      buttonText: Text(
        fieldText,
        style: TextStyle(
          color: Colors.blue[800],
          fontSize: 15,
        ),
      ),
      onConfirm: onConfirm,
      validator: (values) {
        if (values == null || values.isEmpty) {
          return "Будь ласка, виберіть регіон";
        }
        return null;
      },
    );
  }
}
