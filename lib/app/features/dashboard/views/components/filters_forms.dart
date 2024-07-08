import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/custom_drop_down_selector.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
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
  final _maxRangePriceController = TextEditingController();
  final _minRangePriceController = TextEditingController();
  final _phoneController = TextEditingController();
  RangeValues _currentRangeValues = const RangeValues(1000, 40000);

  @override
  void dispose() {
    _idController.dispose();
    _priceController.dispose();
    _roomsController.dispose();
    _regionController.dispose();
    _statusController.dispose();
    _maxRangePriceController.dispose();
    _minRangePriceController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _minRangePriceController.text =
        _currentRangeValues.start.toStringAsFixed(0);
    _maxRangePriceController.text = _currentRangeValues.end.toStringAsFixed(0);
  }

  void _handleRangeChange(RangeValues values) {
    setState(() {
      if (values.start < 1000) {
        _currentRangeValues = RangeValues(1000, values.end);
      } else if (values.end > 40000) {
        _currentRangeValues = RangeValues(values.start, 40000);
      } else {
        _currentRangeValues = values;
      }
      _minRangePriceController.text =
          _currentRangeValues.start.toStringAsFixed(0);
      _maxRangePriceController.text =
          _currentRangeValues.end.toStringAsFixed(0);
    });
  }

  String? _validateMin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка введіть число';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'Будь ласка введіть більше нуля число';
    }
    if (doubleValue < 1000 || doubleValue > 40000) {
      return 'Будь ласка введіть число від 1000 до 40000';
    }
    if (doubleValue > _currentRangeValues.end) {
      return 'Мін число не повинно бути більше Макс';
    }
    return null;
  }

  String? _validateMax(String? value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка введіть число';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'Будь ласка введіть більше нуля число';
    }
    if (doubleValue < 1000 || doubleValue > 40000) {
      return 'Будь ласка введіть число від 1000 до 40000';
    }
    if (doubleValue < _currentRangeValues.start) {
      return 'Мін число не повинно бути більше Макс';
    }
    return null;
  }

  List _selectedRegions = [];
  List _selectedTypes = [];

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

      if (_statusController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'status',
          value: _statusController.text,
          condition: 'equals',
        ));
      }

      if (_minRangePriceController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'Price',
          value: _minRangePriceController.text.toString(),
          condition: 'Greater',
        ));
      }
      if (_maxRangePriceController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'Price',
          value: _maxRangePriceController.text.toString(),
          condition: 'Less',
        ));
      }

      if (_phoneController.text.isNotEmpty) {
        filters.add(FilterCondition(
          property: 'Phone',
          value: _phoneController.text.toString(),
          condition: 'Contains',
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
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _phoneController,
            decoration: decorationForTextFormField('Телефон'),
            validator: (value) {
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              TextFormField(
                  controller: _minRangePriceController,
                  keyboardType: TextInputType.number,
                  decoration: decorationForTextFormField('Мін',
                          icon: const FaIcon(FontAwesomeIcons.hryvniaSign))
                      .copyWith(prefix: const Text('Мін: ')),
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  validator: _validateMin),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _maxRangePriceController,
                  keyboardType: TextInputType.number,
                  decoration: decorationForTextFormField('Макс',
                          icon: const FaIcon(FontAwesomeIcons.hryvniaSign))
                      .copyWith(prefix: const Text('Макс: ')),
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  validator: _validateMax),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 245, 243, 243)),
            child: SliderTheme(
              data: const SliderThemeData(
                  thumbColor: Colors.blue, activeTrackColor: Colors.orange),
              child: RangeSlider(
                values: _currentRangeValues,
                min: 1000,
                max: 40000,
                divisions: 100,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: _handleRangeChange,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          MultiSelectDialogField(
            items: types
                .map((region) => MultiSelectItem<String>(region, region))
                .toList(),
            initialValue: _selectedTypes,
            title: const Text('Тип'),
            buttonIcon: const Icon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: Colors.grey,
            ),
            buttonText: _selectedTypes.isEmpty
                ? const Text('Тип')
                : Text(
                    " Тип: ${_selectedTypes.length.toString()}",
                    overflow: TextOverflow.ellipsis,
                  ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                    width: 1.5,
                    color: const Color.fromARGB(255, 171, 107, 255))),
            onConfirm: (values) {
              setState(() {
                _selectedTypes = values;
              });
              _roomsController.text = _selectedTypes.join(',');
            },
            chipDisplay: MultiSelectChipDisplay.none(),
            validator: (values) {
              if (values == null || values.isEmpty) {
                return 'Виберіть принаймні один тип';
              }
              return null;
            },
          ),
          // DropdownButtonFormField<String>(
          //   autovalidateMode: AutovalidateMode.always,
          //   autofocus: false,
          //   style: const TextStyle(
          //       fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          //   decoration: decorationForTextFormField('Тип'),
          //   onChanged: (val) {
          //     _roomsController.text = val!;
          //   },
          //   icon: const FaIcon(
          //     FontAwesomeIcons.chevronDown,
          //     size: 15,
          //     color: Colors.grey,
          //   ),
          //   items: [...types].map((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          //   // value: types[0],
          // ),
          const SizedBox(
            height: 10,
          ),
          // DropdownButtonFormField<String>(
          //   autovalidateMode: AutovalidateMode.always,
          //   autofocus: false,
          //   style: const TextStyle(
          //       fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          //   decoration: decorationForTextFormField('Район'),
          //   onChanged: (val) {
          //     _regionController.text = val!;
          //   },
          //   icon: const FaIcon(
          //     FontAwesomeIcons.chevronDown,
          //     size: 15,
          //     color: Colors.grey,
          //   ),
          //   items: [...regions].map((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          //   // value: types[0],
          // ),
          MultiSelectDialogField(
            items: regions
                .map((region) => MultiSelectItem<String>(region, region))
                .toList(),
            initialValue: _selectedRegions,
            title: const Text('Район'),
            buttonIcon: const Icon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: Colors.grey,
            ),
            buttonText: _selectedRegions.isEmpty
                ? const Text('Район')
                : Text(
                    " Район: ${_selectedRegions.length.toString()}",
                    overflow: TextOverflow.ellipsis,
                  ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                    width: 1.5,
                    color: const Color.fromARGB(255, 171, 107, 255))),
            onConfirm: (values) {
              setState(() {
                _selectedRegions = values;
              });
              _regionController.text = _selectedRegions.join(',');
            },
            chipDisplay: MultiSelectChipDisplay.none(),
            validator: (values) {
              if (values == null || values.isEmpty) {
                return 'Виберіть принаймні один регіон';
              }
              return null;
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
            decoration: decorationForTextFormField('Статус'),
            onChanged: (val) {
              _statusController.text = val!;
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: Colors.grey,
            ),
            items: [...statuses].map((String value) {
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
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
