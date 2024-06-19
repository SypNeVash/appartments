import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddNewUsers extends StatefulWidget {
  const AddNewUsers({super.key});

  @override
  State<AddNewUsers> createState() => _AddNewUsersState();
}

class _AddNewUsersState extends State<AddNewUsers> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 4,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 55),
              child: const Column(
                children: [
                  FormsListForUsers(),
                  TextFormForAddingNewUser(),
                ],
              )),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}

class FormsListForUsers extends StatelessWidget {
  const FormsListForUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adding new User',
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

class TextFormForAddingNewUser extends StatefulWidget {
  const TextFormForAddingNewUser({Key? key}) : super(key: key);

  @override
  State<TextFormForAddingNewUser> createState() =>
      _TextFormForAddingNewUserState();
}

class _TextFormForAddingNewUserState extends State<TextFormForAddingNewUser> {
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
