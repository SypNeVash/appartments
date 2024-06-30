import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/providers/work_area_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WorkAreaFormFilter extends StatefulWidget {
  const WorkAreaFormFilter({super.key});

  @override
  State<WorkAreaFormFilter> createState() => _WorkAreaFormFilterState();
}

class _WorkAreaFormFilterState extends State<WorkAreaFormFilter> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _statusController = TextEditingController();
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final filters = <FilterCondition>[];

      if (_phoneController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'CustomerCard.PhoneNumber',
          value: _phoneController.text,
          condition: 'contains',
        ));
      }
      if (_statusController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'Task',
          value: _statusController.text,
          condition: 'Equals',
        ));
      }

      Provider.of<WorkAreaProvider>(context, listen: false)
          .searchWorkArea(filters, 1);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _phoneController,
            decoration: decorationForTextFormField('Телефон'),
            validator: (value) {
              return null;
            },
          ),
          const SizedBox(
            height: 25,
          ),
          DropdownButtonFormField<String>(
            autovalidateMode: AutovalidateMode.always,
            autofocus: false,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: decorationForTextFormField('Статус'),
            onChanged: (val) {
              _statusController.text = val!;
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: Colors.grey,
            ),
            items: [...tasks].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // value: types[0],
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 188, 2),
                ),
                onPressed: () async {
                  _submitForm();
                },
                child: const Text(
                  'Пошук',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }
}
