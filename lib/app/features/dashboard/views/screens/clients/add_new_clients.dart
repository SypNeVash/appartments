import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:apartments/app/utils/services/validator.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class AddingNewClients extends StatefulWidget {
  const AddingNewClients({Key? key}) : super(key: key);

  @override
  State<AddingNewClients> createState() => _AddingNewClientsState();
}

class _AddingNewClientsState extends State<AddingNewClients> {
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
          return const SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  children: [
                    FormsList(),
                    TextFormForAddingNewClients(),
                  ],
                ),
              ));
        }, tabletBuilder: (context, constraints) {
          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: const Column(
                    children: [
                      FormsList(),
                      TextFormForAddingNewClients(),
                      SizedBox(
                        height: 35,
                      )
                    ],
                  )));
        }, desktopBuilder: (context, constraints) {
          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Column(
                      children: [
                        FormsList(),
                        TextFormForAddingNewClients(),
                        SizedBox(
                          height: 35,
                        )
                      ],
                    )),
              ));
        })));
  }
}

class FormsList extends StatelessWidget {
  const FormsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Додати нового клієнта',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'Будь ласка, заповніть форму',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class TextFormForAddingNewClients extends StatefulWidget {
  const TextFormForAddingNewClients({Key? key}) : super(key: key);

  @override
  State<TextFormForAddingNewClients> createState() =>
      _TextFormForAddingNewClientsState();
}

class _TextFormForAddingNewClientsState
    extends State<TextFormForAddingNewClients> {
  final TextEditingController name = TextEditingController();
  final TextEditingController passport = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController status = TextEditingController();
  final TextEditingController comments = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String errorText = '';
  bool _isValid = true;

  Future<bool> postClientData() async {
    Dio dio = Dio();
    String apiUrl = 'https://realtor.azurewebsites.net/api/CustomerCards';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    String uuid = const Uuid().v4();

    Map<String, String> datas = {
      "id": uuid,
      "name": name.text,
      "passport": passport.text,
      "phoneNumber": phoneNumber.text,
      "status": status.text,
      "comment": comments.text
    };

    Response response = await dio.post(
      apiUrl,
      data: datas,
      options: Options(
        contentType: 'application/json',
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    name.dispose();
    passport.dispose();
    phoneNumber.dispose();
    status.dispose();
    comments.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All information is valid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: decorationForTextFormField("Им'я"),
            onChanged: (val) {
              name.text = val;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: decorationForTextFormField('Паспорт'),
            onChanged: (val) {
              passport.text = val;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: decorationForTextFormField('Телефон'),
            onChanged: (val) {
              phoneNumber.text = val;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          DropdownButtonFormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofocus: false,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            decoration: decorationForTextFormField('Статус').copyWith(
              border: const OutlineInputBorder(),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _isValid ? Colors.blue : Colors.red,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (val) {
              status.text = val!;
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 15,
              color: Colors.grey,
            ),
            hint: const Text(
              'Статус',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 112, 112, 112),
              ),
            ),
            validator: Validator.validateDropDefaultData,
            items: rolesOfClient.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            textCapitalization: TextCapitalization.sentences,
            autofocus: false,
            maxLines: 5,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            decoration: decorationForTextFormField('Comments'),
            onChanged: (val) {
              comments.text = val;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            errorText,
            style: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 45,
          ),
          SizedBox(
            width: 250,
            height: 40,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 188, 2),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _onSubmit();
                    var cancel = BotToast.showLoading();
                    final done = await postClientData();
                    print('done: $done');
                    if (done == true) {
                      cancel();
                      Navigator.of(context).pop();
                    } else {
                      cancel();
                      setState(() {
                        errorText = 'Error: Please check and try again';
                      });
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
          ),
        ],
      ),
    );
  }
}

textShow() {
  return const Text('dddd');
}
