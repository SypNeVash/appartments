import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class WorkingAreSeparation extends StatelessWidget {
  const WorkingAreSeparation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Flexible(flex: 4, child: WorkingAreaForm()),
        Flexible(flex: 1, child: WorkingAreaNotification()),
      ],
    );
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
    MultiSelectItem<String>('Region 1', 'Region 1'),
    MultiSelectItem<String>('Region 2', 'Region 2'),
    MultiSelectItem<String>('Region 3', 'Region 3'),
    MultiSelectItem<String>('Region 4', 'Region 4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Working Area Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: idController,
                decoration: decorationForTextFormField('ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ID';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
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
                controller: customerPhoneNumberController,
                decoration: decorationForTextFormField('Customer Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Customer Phone Number';
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
                    fontSize: 16,
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
                  "Select Regions",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    CustomerCard customerCard = CustomerCard(
                      id: customerIdController.text,
                      name: customerNameController.text,
                      passport: customerPassportController.text,
                      phoneNumber: customerPhoneNumberController.text,
                      role: customerRoleController.text,
                      status: customerStatusController.text,
                    );

                    WorkingAreaModel workingArea = WorkingAreaModel(
                      id: idController.text,
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

                    print(
                        'Form submitted successfully with data: $workingArea');
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
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
