import 'dart:convert';

import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:uuid/uuid.dart';

import 'work are components/form_headline.dart';

class WorkingAreMainEdit extends StatelessWidget {
  const WorkingAreMainEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Center(
          child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.only(top: 10),
              child: const Column(
                children: [
                  FormHeadline(
                    headLine: 'Adding new working area',
                    subLine: 'Be sure o fill the form',
                  ),
                  WorkingAreaForm()
                ],
              )),
        ),
      ));
    }, tabletBuilder: (context, constraints) {
      return SingleChildScrollView(
          controller: ScrollController(),
          child: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.only(top: 10),
                child: const Column(
                  children: [
                    FormHeadline(
                      headLine: 'Adding new working area',
                      subLine: 'Be sure o fill the form',
                    ),
                    WorkingAreaForm()
                  ],
                )),
          ));
    }, desktopBuilder: (context, constraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(vertical: 55),
                child: const Column(
                  children: [
                    FormHeadline(
                      headLine: 'Adding new working area',
                      subLine: 'Be sure o fill the form',
                    ),
                    WorkingAreaForm()
                  ],
                )),
          ));
    })));
  }
}

class WorkingAreaForm extends StatefulWidget {
  const WorkingAreaForm({super.key});
  @override
  _WorkingAreaFormState createState() => _WorkingAreaFormState();
}

class _WorkingAreaFormState extends State<WorkingAreaForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPassportController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController customerRoleController = TextEditingController();
  final TextEditingController customerStatusController =
      TextEditingController();
  final TextEditingController responsibleStaffController =
      TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController minFloorController = TextEditingController();
  final TextEditingController maxFloorController = TextEditingController();
  final TextEditingController residentsController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController chatController = TextEditingController();

  List<String> regions = [];
  List<String> typesAppart = [];
  List<String> chat = [];

  final List<MultiSelectItem<String>> _regionsItems = [
    MultiSelectItem<String>('Region 1', 'Region 1'),
    MultiSelectItem<String>('Region 2', 'Region 2'),
    MultiSelectItem<String>('Region 3', 'Region 3'),
    MultiSelectItem<String>('Region 4', 'Region 4'),
  ];
  final List<MultiSelectItem<String>> _typesAppart = [
    MultiSelectItem<String>('Apartment 1', 'Apartment 1'),
    MultiSelectItem<String>('Apartment 2', 'Apartment 2'),
    MultiSelectItem<String>('Apartment 3', 'Apartment 3'),
    MultiSelectItem<String>('Apartment 4', 'Apartment 4'),
  ];
  CustomerModel? _selectedCustomerCard;
  final Dio _dio = Dio();
  late List<CustomerModel> _customerCards = [];
  bool search = false;
  Future<void> fetchCustomerData() async {
    final phoneNumber = customerPhoneNumberController.text;
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    var url =
        'https://realtor.azurewebsites.net/api/CustomerCards/searchByPhone?phoneNumber=$phoneNumber';
    try {
      if (phoneNumber.isNotEmpty) {
        setState(() {
          search = true;
        });
        Map<String, dynamic> queryParameters = {
          'page': 1,
          'count': 10,
          'value': phoneNumber
        };
        Response response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );
        if (response.statusCode == 200) {
          final data = response.data as List;

          final customerCards = CustomerModelList.fromJsons(data);
          // for (var x in customerCards.customerModel) {
          //   print(x);
          // }

          setState(() {
            _customerCards = customerCards.customerModel;
            search = false;
          });
        }
      }
    } on DioError catch (e) {
      print('Error fetching customer data: ${e.message}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(
              children: [
                TextFormField(
                  controller: customerPhoneNumberController,
                  decoration:
                      decorationForTextFormField('Customer Phone Number')
                          .copyWith(
                              suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: InkWell(
                        onTap: () {
                          fetchCustomerData();
                        },
                        child: search != true
                            ? const FaIcon(FontAwesomeIcons.magnifyingGlass)
                            : const Text('')),
                  )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Customer Phone Number';
                    }
                    return null;
                  },
                ),
                if (search == true) ...[
                  const Positioned(
                    top: 5,
                    right: 5,
                    child: CircularProgressIndicator(),
                  )
                ]
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            if (_customerCards.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: DropdownButtonFormField<CustomerModel?>(
                  hint: const Text('Select Customer'),
                  value: _selectedCustomerCard,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: decorationForTextFormField('Select Customer'),
                  onChanged: (CustomerModel? newValue) {
                    setState(() {
                      _selectedCustomerCard = newValue;
                      customerNameController.text = newValue?.name ?? '';
                      customerPassportController.text =
                          newValue?.passport ?? '';
                      customerIdController.text = newValue?.id ?? '';
                      customerStatusController.text = newValue?.status ?? '';
                    });
                  },
                  items: _customerCards.map((CustomerModel customerCard) {
                    return DropdownMenuItem<CustomerModel>(
                      value: customerCard,
                      child: Text(customerCard.name.toString()),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ),
            TextFormField(
              controller: customerIdController,
              decoration: decorationForTextFormField('Customer ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Customer ID';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: customerNameController,
              decoration: decorationForTextFormField('Customer Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Customer Name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: customerPassportController,
              decoration: decorationForTextFormField('Customer Passport'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Customer Passport';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: customerStatusController,
              decoration: decorationForTextFormField('Customer Status'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Customer Status';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: customerRoleController,
              decoration: decorationForTextFormField('Customer Role'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Customer Role';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: responsibleStaffController,
              decoration: decorationForTextFormField('Responsible Staff'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Responsible Staff';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: rateController,
              decoration: decorationForTextFormField('Rate'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Rate';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: priceController,
              decoration: decorationForTextFormField('Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Price';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: minFloorController,
              decoration: decorationForTextFormField('Min Floor'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Min Floor';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: maxFloorController,
              decoration: decorationForTextFormField('Max Floor'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Max Floor';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: residentsController,
              decoration: decorationForTextFormField('Residents'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Residents';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            MultiSelectDialogField(
              items: _regionsItems,
              title: const Text("Regions"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              buttonIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              buttonText: Text(
                "Select Regions",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 15,
                ),
              ),
              onConfirm: (results) {
                setState(() {
                  regions = List<String>.from(results);
                });
              },
              validator: (values) {
                if (values == null || values.isEmpty) {
                  return "Please select one or more regions";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            MultiSelectDialogField(
              items: _typesAppart,
              title: const Text("Types"),
              selectedColor: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              buttonIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              buttonText: Text(
                "Select Apartment Type",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 15,
                ),
              ),
              onConfirm: (results) {
                setState(() {
                  typesAppart = List<String>.from(typesAppart);
                });
              },
              validator: (values) {
                if (values == null || values.isEmpty) {
                  return "Please select one or more regions";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: linkController,
              decoration: decorationForTextFormField('Link'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Link';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: registrationController,
              decoration: decorationForTextFormField('Registration'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Registration';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: checkInController,
              decoration: decorationForTextFormField('Check In'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Check In';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: commentsController,
              decoration: decorationForTextFormField('Comments'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Comments';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: taskController,
              decoration: decorationForTextFormField('Task'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Task';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: chatController,
              decoration: decorationForTextFormField('Chat'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Chat';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 35,
            ),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 188, 2),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String uuid = const Uuid().v4();
                      CustomerCard customerCard = CustomerCard(
                        id: customerIdController.text,
                        name: customerNameController.text,
                        passport: customerPassportController.text,
                        phoneNumber: customerPhoneNumberController.text,
                        role: customerRoleController.text,
                        status: customerStatusController.text,
                      );

                      WorkingAreaModel workingArea = WorkingAreaModel(
                        id: uuid,
                        customerCard: customerCard,
                        regions: regions,
                        typesAppart: typesAppart,
                        responsibleStaff: responsibleStaffController.text,
                        rate: rateController.text,
                        price: priceController.text,
                        minFloor: minFloorController.text,
                        maxFloor: maxFloorController.text,
                        residents: residentsController.text,
                        link: linkController.text,
                        registration: registrationController.text,
                        checkIn: checkInController.text,
                        comments: commentsController.text,
                        task: taskController.text,
                        chat: chat,
                      );

                        String jsonData = workingArea.toJson();

print(jsonData);
                      WorkAreApi().postWorkAreaClient(jsonData);
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class WorkingAreaNotification extends StatefulWidget {
  const WorkingAreaNotification({super.key});

  @override
  State<WorkingAreaNotification> createState() =>
      _WorkingAreaNotificationState();
}

class _WorkingAreaNotificationState extends State<WorkingAreaNotification> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
