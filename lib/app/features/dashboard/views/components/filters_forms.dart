import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FilterOfAppartments extends StatefulWidget {
  const FilterOfAppartments({super.key});

  @override
  State<FilterOfAppartments> createState() => _FilterOfAppartmentsState();
}

class _FilterOfAppartmentsState extends State<FilterOfAppartments> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _priceController = TextEditingController();
  final _roomsController = TextEditingController();
  final _regionController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _priceController.dispose();
    _roomsController.dispose();
    _regionController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final filters = <FilterCondition>[];

      if (_idController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'id',
          value: _idController.text,
          condition: 'contains',
        ));
      }
      if (_priceController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'price',
          value: _priceController.text,
          condition: 'contains',
        ));
      }
      if (_roomsController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'type',
          value: _roomsController.text,
          condition: 'equals',
        ));
      }
      if (_regionController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'region',
          value: _regionController.text,
          condition: 'equals',
        ));
      }

      if (_statusController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'status',
          value: _statusController.text,
          condition: 'equals',
        ));
      }

      Provider.of<ApartmentProvider>(context, listen: false)
          .searchApartments(filters, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _idController,
            decoration: decorationForTextFormField('ID'),
            validator: (value) {
              return null; // ID is optional, so no validation
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _priceController,
            decoration: decorationForTextFormField('Ціна'),
            validator: (value) {
              return null; // Price is optional, so no validation
            },
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<String>(
            autovalidateMode: AutovalidateMode.always,
            autofocus: false,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: decorationForTextFormField('Тип'),
            onChanged: (val) {
              _roomsController.text = val!;
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: Colors.grey,
            ),
            items: [...types, ""].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // value: types[0],
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<String>(
            autovalidateMode: AutovalidateMode.always,
            autofocus: false,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: decorationForTextFormField('Район'),
            onChanged: (val) {
              _regionController.text = val!;
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: Colors.grey,
            ),
            items: [...regions, ""].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // value: types[0],
          ),
          const SizedBox(
            height: 10,
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
            items: [...statuses, ""].map((String value) {
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

                  // var cancel = BotToast.showLoading();
                  // final done = await postData();
                  // if (done == true) {
                  //   cancel();
                  //   Navigator.pop(context);
                  // }
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
