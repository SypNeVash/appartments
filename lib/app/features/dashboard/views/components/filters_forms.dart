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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _submitSearch(ApartmentProvider provider) {
    String? name =
        _nameController.text.isNotEmpty ? _nameController.text : null;
    double? price = _priceController.text.isNotEmpty
        ? double.tryParse(_priceController.text)
        : null;
    int? id =
        _idController.text.isNotEmpty ? int.tryParse(_idController.text) : null;

    List<FilterCondition> filters = [];
    if (name != null) {
      filters.add(
          FilterCondition(property: 'name', value: name, condition: 'equals'));
    }
    if (price != null) {
      filters.add(FilterCondition(
          property: 'price',
          value: price.toString(),
          condition: 'greater_than'));
    }
    if (id != null) {
      filters.add(FilterCondition(
          property: 'id', value: id.toString(), condition: 'equals'));
    }

    // provider.searchApartments(
    //   page: 1,
    //   limit: 10,
    //   filters: filters.isEmpty ? null : filters,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApartmentProvider>(context);

    return Column(
      children: [
        TextFormField(
          controller: _idController,
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
          controller: _priceController,
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
                _submitSearch(provider);

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
