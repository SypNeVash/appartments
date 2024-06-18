import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/filter_models.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _idController.dispose();
    _priceController.dispose();
    _roomsController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final filters = <FilterCondition>[];

      if (_idController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'id',
          value: _idController.text,
          condition: 'equals',
        ));
      }
      if (_priceController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'price',
          value: _priceController.text,
          condition: 'equals',
        ));
      }
      if (_roomsController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'room',
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

      Provider.of<ApartmentProvider>(context, listen: false)
          .searchApartments(filters);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApartmentProvider>(context);

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
            decoration: decorationForTextFormField('Price'),
            validator: (value) {
              return null; // Price is optional, so no validation
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _roomsController,
            decoration: decorationForTextFormField('Number of Rooms'),
            validator: (value) {
              return null; // Number of Rooms is optional, so no validation
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _regionController,
            decoration: decorationForTextFormField('Region'),
            validator: (value) {
              return null; // Region is optional, so no validation
            },
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
                  'Search',
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
