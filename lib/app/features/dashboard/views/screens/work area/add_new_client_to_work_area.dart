import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/providers/clients_provider.dart';
import 'package:apartments/app/providers/work_area_provider.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'work are components/form_headline.dart';

class WorkingAreMainEdit extends StatefulWidget {
  const WorkingAreMainEdit({super.key});

  @override
  State<WorkingAreMainEdit> createState() => _WorkingAreMainEditState();
}

class _WorkingAreMainEditState extends State<WorkingAreMainEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const DashboardScreen()),
              // );
            },
            icon: const Icon(EvaIcons.arrowBack),
          ),
        ),
        body: SafeArea(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Center(
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.only(top: 10),
                  child: const Column(
                    children: [
                      FormHeadline(
                        headLine: 'Новий робочий простір',
                        subLine: "Обов'язково заповніть форму",
                      ),
                      WorkingAreaForm(),
                      SizedBox(
                        height: 35,
                      )
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
                          headLine: 'Новий робочий простір',
                          subLine: "Обов'язково заповніть форму",
                        ),
                        WorkingAreaForm(),
                        SizedBox(
                          height: 35,
                        )
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
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: const Column(
                      children: [
                        FormHeadline(
                          headLine: 'Новий робочий простір',
                          subLine: "Обов'язково заповніть форму",
                        ),
                        WorkingAreaForm(),
                        SizedBox(
                          height: 35,
                        )
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

  List<String> regions = [];
  List<String> typesAppart = [];
  List<String> chat = [];

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

  showSnackBarForError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Something went wrong',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(
              children: [
                TextFormField(
                  controller: customerPhoneNumberController,
                  decoration:
                      decorationForTextFormField('Номер телефона клієнта')
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
                      return 'Будь ласка, введіть номер телефона клієнта';
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
                  hint: const Text('Виберіть Клієнта'),
                  value: _selectedCustomerCard,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: decorationForTextFormField('Виберіть Клієнта'),
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
            // TextFormField(
            //   controller: customerIdController,
            //   decoration: decorationForTextFormField('Customer ID'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Customer ID';
            //     }
            //     return null;
            //   },
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            TextFormField(
              controller: customerNameController,
              decoration: decorationForTextFormField("Ім'я клієнта"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Будь ласка, введіть ім'я клієнта";
                }
                return null;
              },
            ),
            // const SizedBox(
            //   height: 15,
            // ),
            // TextFormField(
            //   controller: customerPassportController,
            //   decoration: decorationForTextFormField('Customer Passport'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Customer Passport';
            //     }
            //     return null;
            //   },
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            // TextFormField(
            //   controller: customerStatusController,
            //   decoration: decorationForTextFormField('Customer Status'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Customer Status';
            //     }
            //     return null;
            //   },
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            // TextFormField(
            //   controller: customerRoleController,
            //   decoration: decorationForTextFormField('Customer Role'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Customer Role';
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: responsibleStaffController,
              decoration: decorationForTextFormField('Відповідальна персона'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Будь ласка, введіть відповідальу персону';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            // TextFormField(
            //   controller: rateController,
            //   decoration: decorationForTextFormField('Rate'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Rate';
            //     }
            //     return null;
            //   },
            // ),
            DropdownButtonFormField<String>(
              autovalidateMode: AutovalidateMode.always,
              autofocus: false,
              isDense: true,
              style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w500),
              decoration: decorationForTextFormField('Тариф'),
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
              // value: types[0],
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: priceController,
              decoration: decorationForTextFormField('Ціна'),
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
              decoration: decorationForTextFormField('Мінімальний поверх'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введіть мінімальний поверх';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: maxFloorController,
              decoration: decorationForTextFormField('Максимальний поверх'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введіть максимальний поверх';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: residentsController,
              decoration: decorationForTextFormField('Громадянство'),
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
              items: regionsItemsMulti,
              title: const Text("Район"),
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
                "Виберіть райони",
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
                  return "Виберіть один або декілька районів";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            MultiSelectDialogField(
              items: typesAppartMulti,
              title: const Text("Типи квартир"),
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
                "Виберіть типи квартир",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 15,
                ),
              ),
              onConfirm: (result) {
                setState(() {
                  typesAppart = List<String>.from(result);
                });
              },
              validator: (values) {
                if (values == null || values.isEmpty) {
                  return "Виберіть один або декілька типів";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: linkController,
              decoration: decorationForTextFormField('Привязка'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введіть посилання';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: registrationController,
              decoration: decorationForTextFormField('Реєстрація'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Будь ласка, введіть реєстрацію';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: checkInController,
              decoration: decorationForTextFormField('Заїзд'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Будь ласка, введіть дату заїзда';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: commentsController,
              maxLines: 5,
              decoration: decorationForTextFormField('Коментар'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Будь ласка, введіть коментарь';
                }
                return null;
              },
            ),
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
              decoration: decorationForTextFormField('Завдання'),
              onChanged: (val) {
                taskController.text = val!;
              },
              icon: const FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 15,
                color: Colors.grey,
              ),
              items: [...tasks].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // value: typ
            // TextFormField(
            //   controller: taskController,
            //   decoration: decorationForTextFormField('Task'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Task';
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(
              height: 35,
            ),
            // TextFormField(
            //   controller: chatController,
            //   decoration: decorationForTextFormField('Chat'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Chat';
            //     }
            //     return null;
            //   },
            // ),
            // const SizedBox(
            //   height: 35,
            // ),
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 188, 2),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String uuid = const Uuid().v4();
                      CustomerCard customerCard = CustomerCard(
                        id: customerIdController.text,
                        name: customerNameController.text,
                        passport: customerPassportController.text,
                        phoneNumber: customerPhoneNumberController.text,
                        role: customerRoleController.text,
                        status: customerStatusController.text,
                        comment: customerStatusController.text,
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
                      var cancel = BotToast.showLoading();

                      final done =
                          await WorkAreApi().postWorkAreaClient(jsonData);
                      if (done == true) {
                        cancel();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Provider.of<WorkAreaProvider>(context, listen: false)
                              .fetchWorkingAreaList(1);
                        });
                        Navigator.pop(context);
                      } else {
                        showSnackBarForError();
                      }
                    }
                  },
                  child: const Text(
                    'Зберегти',
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
