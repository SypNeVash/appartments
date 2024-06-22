import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/providers/clients_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientSearchForm extends StatefulWidget {
  const ClientSearchForm({super.key});

  @override
  State<ClientSearchForm> createState() => _ClientSearchFormState();
}

class _ClientSearchFormState extends State<ClientSearchForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final filters = <FilterCondition>[];

      if (_phoneController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'phoneNumber',
          value: _phoneController.text,
          condition: 'contains',
        ));
      }

      Provider.of<ClientProvider>(context, listen: false)
          .searchClients(filters, 1);
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
            decoration: decorationForTextFormField('Phone'),
            validator: (value) {
              return null;
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
