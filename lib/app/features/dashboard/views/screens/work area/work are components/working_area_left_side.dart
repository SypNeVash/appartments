import 'dart:convert';

import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/features/dashboard/views/screens/work%20area/work%20are%20components/multi_select.dart';
import 'package:apartments/app/models/task_model.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/providers/work_area_provider.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../clients/edit_clients_dat.dart';
import 'working_area_right_side.dart';

class WorkingFieldEditForm extends StatefulWidget {
  final bool? isMobile;
  const WorkingFieldEditForm({this.isMobile, super.key});
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
  final idController = TextEditingController();
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

  List<String> chat = [];

  List<String> regionsFromServer = [];
  List<String> predefinedRegions = regions;
  List<MultiSelectItem<String>> _regionsItems = [];
  List<String> selectedRegions = [];

  List<String> typesAppartFromServer = [];
  List<String> predefinedTypesApart = types;
  List<MultiSelectItem<String>> _typesApartItems = [];
  List<String> selectedAparts = [];
  String? selectedTask;
  String? selectedRate;
  bool isLoading = false;
  List<String> _responsibleStaff = [];
  bool _isFetching = false;

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
  bool isEditingRegions = false;

  getWorkAreaUsingID() async {
    workingAreaModel = await WorkAreApi().fetchWorkingAreaDetailsById();
    customerIdController.text = workingAreaModel.customerCard!.id!;
    customerNameController.text = workingAreaModel.customerCard!.name!;
    customerPassportController.text = workingAreaModel.customerCard!.passport!;
    customerPhoneNumberController.text =
        workingAreaModel.customerCard!.phoneNumber!;
    customerRoleController.text = workingAreaModel.customerCard!.role!;
    customerStatusController.text = workingAreaModel.customerCard!.status!;
    idController.text = workingAreaModel.id!;
    responsibleStaffController.text = workingAreaModel.responsibleStaff!;
    rateController.text = workingAreaModel.rate!;
    selectedRate = workingAreaModel.rate!;
    priceController.text = workingAreaModel.price!;
    minFloorController.text = workingAreaModel.minFloor!;
    maxFloorController.text = workingAreaModel.maxFloor!;
    residentsController.text = workingAreaModel.residents!;
    linkController.text = workingAreaModel.link!;
    registrationController.text = workingAreaModel.registration!;
    checkInController.text = workingAreaModel.checkIn!;
    commentsController.text = workingAreaModel.comments!;
    taskController.text = workingAreaModel.task!;
    final regionsFrom = workingAreaModel.regions;
    final typesForm = workingAreaModel.typesAppart;
    selectedTask = workingAreaModel.task;

    setState(() {
      regionsFromServer = regionsFrom!;
      typesAppartFromServer = typesForm!;
      _combineMultiSelectors();
    });
  }

  void _combineMultiSelectors() {
    Set<String> combinedRegionsSet = {
      ...predefinedRegions,
      ...regionsFromServer
    };

    Set<String> combinedApartSet = {
      ...predefinedTypesApart,
      ...typesAppartFromServer
    };
    List<String> combinedRegions = combinedRegionsSet.toList();
    List<String> combinedApartsType = combinedApartSet.toList();

    setState(() {
      _regionsItems = combinedRegions
          .map((region) => MultiSelectItem<String>(region, region))
          .toList();
      selectedRegions = List<String>.from(regionsFromServer);
      _typesApartItems = combinedApartsType
          .map((region) => MultiSelectItem<String>(region, region))
          .toList();
      selectedAparts = List<String>.from(typesAppartFromServer);
    });
  }

  bool? _isMobile;
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
    idController.dispose();
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
    setState(() {
      isLoading = true;
    });
    final workAreaId = await SPHelper.getWorkAreaIDSharedPreference();
    final nameOfUser = await SPHelper.getNameSharedPreference() ?? '';
    final dateTime = DateTime.now();
    CustomerCard customerCard = CustomerCard(
      id: customerIdController.text,
      name: customerNameController.text,
      passport: customerPassportController.text,
      phoneNumber: customerPhoneNumberController.text,
      role: customerRoleController.text,
      status: customerStatusController.text,
    );

    TaskModel tasks = TaskModel(
        id: const Uuid().v4(),
        type: taskController.text,
        clientPhone: customerPhoneNumberController.text,
        userName: nameOfUser,
        date: dateTime.toString(),
        doneDate: dateTime.toString(),
        description: commentsController.text,
        status: customerStatusController.text);
    WorkingAreaModel workingArea = WorkingAreaModel(
      id: workAreaId,
      customerCard: customerCard,
      // tasks: tasks,
      regions: selectedRegions,
      typesAppart: selectedAparts,
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
    );
    final jsonData = jsonEncode(workingArea.toMap());
    bool success = await WorkAreApi().editWorkAreaClient(jsonData);
    if (success) {
      isLoading = false;
      showSnackBarForConfirmation();

      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<WorkAreaProvider>(context, listen: false)
            .fetchWorkingAreaList(1);
      });
    } else {
      isLoading = false;
      showSnackBarForError();
      setState(() {});
    }
  }

  showSnackBarForConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Center(
          child: Text(
            'Успішно змінено',
            style: TextStyle(color: Colors.white),
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  showSnackBarForError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Спробувати ще раз')),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Color _getColorForValue(String? value) {
    switch (value) {
      case 'Зустріч':
        return const Color.fromARGB(255, 171, 107, 255);
      case 'Передзвонити пізніше':
        return Colors.yellow;
      case 'Сплачено':
        return Colors.green;
      case 'Заселений':
        return const Color.fromARGB(255, 175, 219, 255);
      case 'Заморожений':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Future<void> fetchCResponsibleStaff() async {
    Dio _dio = Dio();
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    var url = 'https://realtor.azurewebsites.net/api/Authenticate/getstuff';
    try {
      setState(() {
        _isFetching = true;
      });

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      if (response.statusCode == 200) {
        final List data = response.data;
        setState(() {
          _responsibleStaff = List<String>.from(data);
          _isFetching = false;
        });
      }
    } on DioError catch (e) {
      print('Error fetching customer data: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 600) {
      _isMobile = true;
    } else if (screenSize.width < 1200) {
      _isMobile = false;
    } else {
      _isMobile = false;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
            // );
          },
          icon: const Icon(EvaIcons.arrowBack),
        ),
        title: const Text(
          'Робочий простір',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          _isMobile == true
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const WorkingAreaRightSide(isMobile: true)),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 30,
                        color: Colors.black,
                      )),
                )
              : const SizedBox(),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 146, 162, 190)
                              .withOpacity(0.5),
                          spreadRadius: -5,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Дані клієнта',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.userLarge,
                                    size: 13,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    customerNameController.text,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 87, 85, 87)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.phoneFlip,
                                    size: 13,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Expanded(
                                    child: Text(
                                      customerPhoneNumberController.text,
                                      style: const TextStyle(
                                          // overflow: TextOverflow.ellipsis,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 87, 85, 87)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.orange),
                                child: Text(
                                  customerStatusController.text,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await SPHelper.saveClientsIDSharedPreference(
                                customerIdController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditClientsData()),
                            );
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.pencil,
                            size: 15,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 146, 162, 190)
                                .withOpacity(0.5),
                            spreadRadius: -5,
                            blurRadius: 10,
                            offset: const Offset(
                                0, 8), // changes position of shadow
                          ),
                        ],
                        color: Colors.white),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (_responsibleStaff.isEmpty) {
                                fetchCResponsibleStaff();
                              }
                            },
                            child: AbsorbPointer(
                              absorbing: _isFetching,
                              child: DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autofocus: false,
                                isDense: true,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w500),
                                decoration: _responsibleStaff.isEmpty
                                    ? _isFetching == false
                                        ? nonActiveDecorationTextField(
                                            responsibleStaffController.text)
                                        : nonActiveDecorationTextField('')
                                    : decorationForTextFormField(''),
                                onChanged: (val) {
                                  responsibleStaffController.text = val!;
                                },
                                icon: _isFetching == true
                                    ? const SizedBox(
                                        height: 17,
                                        width: 17,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                        ))
                                    : const FaIcon(
                                        FontAwesomeIcons.chevronDown,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                items: _responsibleStaff.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: _responsibleStaff.isEmpty == true
                                    ? responsibleStaffController.text
                                    : _responsibleStaff.contains(
                                            responsibleStaffController.text)
                                        ? _responsibleStaff
                                            .singleWhere((element) {
                                            return element ==
                                                responsibleStaffController.text;
                                          })
                                        : _responsibleStaff[0],
                              ),
                            ),
                          ),
                          // buildEditableTextField(
                          //   controller: responsibleStaffController,
                          //   isEditing: isEditingResponsibleStaff,
                          //   label: 'Відповідальна персона',
                          //   onEdit: () {
                          //     setState(() {
                          //       isEditingResponsibleStaff = true;
                          //     });
                          //   },
                          //   onSave: () {
                          //     setState(() {
                          //       isEditingResponsibleStaff = false;
                          //     });
                          //   },
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            autovalidateMode: AutovalidateMode.always,
                            autofocus: false,
                            isDense: true,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500),
                            decoration: decorationForTextFormField('Rate'),
                            onChanged: (val) {
                              rateController.text = val!;
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.chevronDown,
                              size: 15,
                              color: Colors.grey,
                            ),
                            items: [...rates].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: rates.contains(selectedRate)
                                ? selectedRate
                                : rates[0],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          MultiSelector(
                            items: _regionsItems,
                            initialValue: selectedRegions,
                            fieldText: 'Вибрати район',
                            onConfirm: (results) {
                              setState(() {
                                selectedRegions = List<String>.from(results);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MultiSelector(
                            items: _typesApartItems,
                            initialValue: selectedAparts,
                            fieldText: 'Вибрати тип апартаментів',
                            onConfirm: (results) {
                              setState(() {
                                selectedAparts = List<String>.from(results);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          buildEditableTextField(
                            controller: priceController,
                            isEditing: isEditingPrice,
                            label: "Ціна",
                            onEdit: () {
                              setState(() {
                                isEditingPrice = true;
                              });
                            },
                            onSave: () {
                              setState(() {
                                isEditingPrice = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildEditableTextField(
                                  controller: minFloorController,
                                  isEditing: isEditingMinFloor,
                                  label: "Мінімальний поверх",
                                  onEdit: () {
                                    setState(() {
                                      isEditingMinFloor = true;
                                    });
                                  },
                                  onSave: () {
                                    setState(() {
                                      isEditingMinFloor = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: buildEditableTextField(
                                  controller: maxFloorController,
                                  isEditing: isEditingMaxFloor,
                                  label: "Максимальний поверх",
                                  onEdit: () {
                                    setState(() {
                                      isEditingMaxFloor = true;
                                    });
                                  },
                                  onSave: () {
                                    setState(() {
                                      isEditingMaxFloor = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildEditableTextField(
                            controller: residentsController,
                            isEditing: isEditingResidents,
                            label: 'Громадянство',
                            onEdit: () {
                              setState(() {
                                isEditingResidents = true;
                              });
                            },
                            onSave: () {
                              setState(() {
                                isEditingResidents = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildEditableTextField(
                            controller: linkController,
                            isEditing: isEditingLink,
                            label: "Прив'язка",
                            onEdit: () {
                              setState(() {
                                isEditingLink = true;
                              });
                            },
                            onSave: () {
                              setState(() {
                                isEditingLink = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildEditableTextField(
                            controller: registrationController,
                            isEditing: isEditingRegions,
                            label: 'Прописка',
                            onEdit: () {
                              setState(() {
                                isEditingRegions = true;
                              });
                            },
                            onSave: () {
                              setState(() {
                                isEditingRegions = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildEditableTextField(
                            controller: checkInController,
                            isEditing: isEditingCheckIn,
                            label: 'Заїзд',
                            onEdit: () {
                              setState(() {
                                isEditingCheckIn = true;
                              });
                            },
                            onSave: () {
                              setState(() {
                                isEditingCheckIn = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildEditableTextField(
                              controller: commentsController,
                              isEditing: isEditingComments,
                              label: 'Комент',
                              onEdit: () {
                                setState(() {
                                  isEditingComments = true;
                                });
                              },
                              onSave: () {
                                setState(() {
                                  isEditingComments = false;
                                });
                              },
                              bigTextField: true),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            autovalidateMode: AutovalidateMode.always,
                            autofocus: false,
                            isDense: true,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500),
                            decoration:
                                decorationForTextFormField('Завдання').copyWith(
                              fillColor: _getColorForValue(taskController.text),
                            ),
                            onChanged: (val) {
                              _getColorForValue(val);

                              taskController.text = val!;
                              setState(() {});
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.chevronDown,
                              size: 15,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            items: tasks.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: tasks.contains(selectedTask)
                                ? selectedTask
                                : tasks[0],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      //  bottomNavigationBar: BottomNavigationBar(
      //     onTap: onTabTapped,  // Handle tab taps
      //     currentIndex: _currentIndex,  // Highlight the selected tab
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.search),
      //         label: 'Search',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: 'Profile',
      //       )
      //     ],
      //   ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveData();
        },
        backgroundColor: Colors.orange,
        child: isLoading == true
            ? const CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Colors.white,
              )
            : const FaIcon(
                FontAwesomeIcons.cloudArrowUp,
                color: Colors.white,
              ),
      ),
    );
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
        icon: IconButton(
            onPressed: () {}, icon: const Icon(Icons.notifications))),
    BottomNavigationBarItem(
        icon:
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)))
  ];
  Widget buildEditableTextField({
    required TextEditingController controller,
    required bool isEditing,
    required String label,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    bool? bigTextField,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: controller,
            maxLines: bigTextField == true ? 5 : null,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black),
            decoration: decorationForTextFormField(label).copyWith(
              fillColor: !isEditing
                  ? const Color.fromARGB(255, 240, 245, 255)
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: !isEditing
                    ? BorderSide.none
                    : const BorderSide(
                        color: Color.fromARGB(255, 171, 107, 255), width: 1.5),
              ),
            ),
            readOnly: !isEditing,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        if (!isEditing)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.penToSquare),
            onPressed: onEdit,
          ),
        if (isEditing)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.floppyDisk),
            onPressed: onSave,
          ),
      ],
    );
  }
}
