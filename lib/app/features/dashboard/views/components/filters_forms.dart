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
  final TextEditingController _propertyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  @override
  void dispose() {
    _propertyController.dispose();
    _valueController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApartmentProvider>(context);

    return Column(
      children: [
        TextFormField(
          controller: _propertyController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Address'),
          onChanged: (val) {},
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _valueController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Phone number'),
          onChanged: (val) {},
        ),
        const SizedBox(
          height: 25,
        ),
        TextFormField(
          controller: _conditionController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Phone number'),
          onChanged: (val) {},
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
                String property = _propertyController.text;
                String value = _valueController.text;
                String condition = _conditionController.text;

                List<FilterCondition> filters = [
                  FilterCondition(
                      property: property, value: value, condition: condition),
                ];

                provider.searchApartments(filters);

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
    );
  }
}
