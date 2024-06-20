import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
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
        body: SafeArea(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
      return const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            FormsList(),
            TextFormForAddingNewApt(),
          ],
        ),
      ));
    }, tabletBuilder: (context, constraints) {
      return SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const Column(
                children: [
                  FormsList(),
                  TextFormForAddingNewApt(),
                ],
              )));
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
                    FormsList(),
                    TextFormForAddingNewApt(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adding new Customer',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'Please fill the form',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class TextFormForAddingNewApt extends StatefulWidget {
  const TextFormForAddingNewApt({Key? key}) : super(key: key);

  @override
  State<TextFormForAddingNewApt> createState() =>
      _TextFormForAddingNewAptState();
}

class _TextFormForAddingNewAptState extends State<TextFormForAddingNewApt> {
  final TextEditingController name = TextEditingController();
  final TextEditingController surname = TextEditingController();
  final TextEditingController patronymic = TextEditingController();
  final TextEditingController passport = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController role = TextEditingController();
  final TextEditingController status = TextEditingController();

  String errorText = '';

  Future<bool> postClientData() async {
    Dio dio = Dio();
    String apiUrl = 'https://realtor.azurewebsites.net/api/CustomerCards';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    String uuid = const Uuid().v4();
    try {
      Map<String, String> datas = {
        "id": uuid,
        "name": name.text,
        "surname": surname.text,
        "patronymic": patronymic.text,
        "passport": passport.text,
        "phoneNumber": phoneNumber.text,
        "address": address.text,
        "birthday": birthday.text,
        "password": password.text,
        "username": username.text,
        "email": email.text,
      };

      Response response = await dio.post(
        apiUrl,
        data: datas,
        options: Options(
          contentType: 'application/json',
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  var statusOfClient = [
    "Recall",
    "Meet",
    "Inprogress",
    "Finished",
    "Freezed",
    "Returned",
    "Realtor"
  ];
  var rolesOfClient = [
    "Stuff",
    "Customer",
  ];
  @override
  void dispose() {
    name.dispose();
    surname.dispose();
    patronymic.dispose();
    passport.dispose();
    phoneNumber.dispose();
    address.dispose();
    birthday.dispose();
    password.dispose();
    username.dispose();
    email.dispose();
    role.dispose();
    status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Name'),
          onChanged: (val) {
            name.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Surname'),
          onChanged: (val) {
            surname.text = val;
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
          decoration: decorationForTextFormField('Patronymic'),
          onChanged: (val) {
            patronymic.text = val;
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
          decoration: decorationForTextFormField('Passport'),
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
          decoration: decorationForTextFormField('Phone Number'),
          onChanged: (val) {
            phoneNumber.text = val;
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
          decoration: decorationForTextFormField(
            'Address',
          ),
          onChanged: (val) {
            address.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Birthday'),
          onChanged: (val) {
            birthday.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Password'),
          onChanged: (val) {
            password.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Username'),
          onChanged: (val) {
            username.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Email'),
          onChanged: (val) {
            email.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.always,
          autofocus: false,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Roles'),
          onChanged: (val) {
            role.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          hint: const Text('Role'),
          items: rolesOfClient.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: rolesOfClient[0],
        ),
        const SizedBox(
          height: 15,
        ),
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.always,
          autofocus: false,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Status'),
          onChanged: (val) {
            role.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          hint: const Text('Status'),
          items: statusOfClient.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: statusOfClient[2],
        ),
        Text(
          errorText,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 55,
        ),
        SizedBox(
          width: 250,
          height: 40,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 188, 2),
              ),
              onPressed: () async {
                var cancel = BotToast.showLoading();
                final done = await postClientData();
                if (done == true) {
                  cancel();
                  Navigator.of(context).pop();
                } else {
                  cancel();
                  setState(() {
                    errorText = 'Error: Please check and try again';
                  });
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )),
        ),
      ],
    );
  }
}

textShow() {
  return const Text('dddd');
}
