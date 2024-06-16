import 'dart:convert';
import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/utils/services/apartment_image_service.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

var types = [
  "1 кімнатна",
  "2 кімнатна",
  "3 кімнатна",
  "4 кімнатна",
  "Студія",
  "Приватний будинок",
  "Частина будинку",
];

var regions = [
  "Галицький",
  "Залізничний",
  "Личаківський",
  "Франківський",
  "Шевченківський",
  "Сихівський",
];

var cities = [
  "Львів",
];

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
          'Adding new Client',
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
  final String apiUrl = 'https://realtor.azurewebsites.net/api/RentObjects';
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
  DateTime now = DateTime.now();

  Future<bool> postData() async {
    try {
      String uuid = const Uuid().v4();
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      final listOfImages = await ApiClient().sendImages(context, accessToken);
      final response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode(
            <String, dynamic>{
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
            },
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    print(now);
    super.initState();
  }

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
                final done = await postData();
                if (done == true) {
                  cancel();
                  Navigator.of(context).pop();
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
  return Text('dddd');
}
