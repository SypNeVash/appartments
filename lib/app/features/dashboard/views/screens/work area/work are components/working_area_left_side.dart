import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WorkingFieldEditForm extends StatefulWidget {
  const WorkingFieldEditForm({super.key});
  @override
  _WorkingFieldEditFormState createState() => _WorkingFieldEditFormState();
}

class _WorkingFieldEditFormState extends State<WorkingFieldEditForm> {
  final _formKey = GlobalKey<FormState>();
  late WorkingAreaModel workingAreaModel;
  final customerIdController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerPassportController = TextEditingController();
  final customerPhoneNumberController = TextEditingController();
  final customerRoleController = TextEditingController();
  final customerStatusController = TextEditingController();
  final responsibleStaffController = TextEditingController();
  final rateController = TextEditingController();
  final priceController = TextEditingController();
  final minFloorController = TextEditingController();
  final maxFloorController = TextEditingController();
  final residentsController = TextEditingController();
  final linkController = TextEditingController();
  final registrationController = TextEditingController();
  final checkInController = TextEditingController();
  final commentsController = TextEditingController();
  final taskController = TextEditingController();
  final List<String> regions = [];
  final List<String> typesAppart = [];
  final List<String> chat = [];

  // Edit states
  bool isEditingCustomerId = false;
  bool isEditingCustomerName = false;
  bool isEditingCustomerPassport = false;
  bool isEditingCustomerPhoneNumber = false;
  bool isEditingCustomerRole = false;
  bool isEditingCustomerStatus = false;
  bool isEditingResponsibleStaff = false;
  bool isEditingRate = false;
  bool isEditingPrice = false;
  bool isEditingMinFloor = false;
  bool isEditingMaxFloor = false;
  bool isEditingResidents = false;
  bool isEditingLink = false;
  bool isEditingRegistration = false;
  bool isEditingCheckIn = false;
  bool isEditingComments = false;
  bool isEditingTask = false;

  getWorkAreaUsingID() async {
    workingAreaModel = await WorkAreApi().fetchWorkingAreaDetailsById();
    customerNameController.text = workingAreaModel.customerCard.name;
    customerPassportController.text = workingAreaModel.customerCard.passport;
    customerPhoneNumberController.text =
        workingAreaModel.customerCard.phoneNumber;
    customerRoleController.text = workingAreaModel.customerCard.role;
    customerStatusController.text = workingAreaModel.customerCard.status;
    responsibleStaffController.text = workingAreaModel.responsibleStaff;
    rateController.text = workingAreaModel.rate;
    priceController.text = workingAreaModel.price;
    minFloorController.text = workingAreaModel.minFloor;
    maxFloorController.text = workingAreaModel.maxFloor;
    residentsController.text = workingAreaModel.residents;
    linkController.text = workingAreaModel.link;
    registrationController.text = workingAreaModel.registration;
    checkInController.text = workingAreaModel.checkIn;
    commentsController.text = workingAreaModel.comments;
    taskController.text = workingAreaModel.task;
  }

  @override
  void initState() {
    getWorkAreaUsingID();
    super.initState();
  }

  @override
  void dispose() {
    customerIdController.dispose();
    customerNameController.dispose();
    customerPassportController.dispose();
    customerPhoneNumberController.dispose();
    customerRoleController.dispose();
    customerStatusController.dispose();
    responsibleStaffController.dispose();
    rateController.dispose();
    priceController.dispose();
    minFloorController.dispose();
    maxFloorController.dispose();
    residentsController.dispose();
    linkController.dispose();
    registrationController.dispose();
    checkInController.dispose();
    commentsController.dispose();
    taskController.dispose();
    super.dispose();
  }

  void saveData() async {
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
      // bool success = await WorkAreApi().postWorkAreaClient(jsonData);

      // if (success) {
      //   print('Data sent successfully');
      // } else {
      //   print('Failed to send data');
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                buildEditableTextField(
                  controller: customerPhoneNumberController,
                  isEditing: isEditingCustomerId,
                  label: 'Customer ID',
                  onEdit: () {
                    setState(() {
                      isEditingCustomerId = true;
                    });
                  },
                  onSave: () {
                    setState(() {
                      isEditingCustomerId = false;
                    });
                  },
                ),
                buildEditableTextField(
                  controller: customerNameController,
                  isEditing: isEditingCustomerName,
                  label: 'Customer Name',
                  onEdit: () {
                    setState(() {
                      isEditingCustomerName = true;
                    });
                  },
                  onSave: () {
                    setState(() {
                      isEditingCustomerName = false;
                    });
                  },
                ),
                // Repeat for other fields
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveData,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget buildEditableTextField({
    required TextEditingController controller,
    required bool isEditing,
    required String label,
    required VoidCallback onEdit,
    required VoidCallback onSave,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
            readOnly: !isEditing,
          ),
        ),
        if (!isEditing)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        if (isEditing)
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: onSave,
          ),
      ],
    );
  }
}
