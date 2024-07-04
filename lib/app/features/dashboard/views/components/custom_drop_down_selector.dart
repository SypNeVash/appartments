import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MultiSelectDropdownExample extends StatefulWidget {
  final List<String> regions;

  const MultiSelectDropdownExample({Key? key, required this.regions})
      : super(key: key);

  @override
  _MultiSelectDropdownExampleState createState() =>
      _MultiSelectDropdownExampleState();
}

class _MultiSelectDropdownExampleState
    extends State<MultiSelectDropdownExample> {
  List<String> _selectedRegions = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Selected Regions: ${_selectedRegions.isEmpty ? 'None' : _selectedRegions.join(', ')}'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Regions',
                border: OutlineInputBorder(),
                icon: FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: 15,
                  color: Colors.grey,
                ),
              ),
              value: null,
              items: widget.regions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (selectedItem) {
                setState(() {
                  if (_selectedRegions.contains(selectedItem!)) {
                    _selectedRegions.remove(selectedItem);
                  } else {
                    _selectedRegions.add(selectedItem);
                  }
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return widget.regions.map<Widget>((String item) {
                  return Text(item);
                }).toList();
              },
              validator: (value) {
                if (_selectedRegions.isEmpty) {
                  return 'Please select at least one region';
                }
                return null;
              },
              isExpanded: true,
              icon: const FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
