import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddNewUsers extends StatefulWidget {
  const AddNewUsers({super.key});

  @override
  State<AddNewUsers> createState() => _AddNewUsersState();
}

class _AddNewUsersState extends State<AddNewUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(EvaIcons.arrowBack),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding:
                      const EdgeInsets.symmetric(vertical: 55, horizontal: 25),
                  child: const Column(
                    children: [
                      FormsListForUsers(),
                      TextFormForAddingNewUser(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class FormsListForUsers extends StatelessWidget {
  const FormsListForUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
  final TextEditingController username = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController role = TextEditingController();

  String errorText = '';

  Future<bool> postClientData() async {
    Dio dio = Dio();
    String apiUrl =
        'https://realtor.azurewebsites.net/api/Authenticate/register';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    try {
      Map<String, String> datas = {
        // "id": uuid,
        "username": username.text,
        "password": password.text,
        "fullName": fullName.text,
        "role": role.text,
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
    username.dispose();
    fullName.dispose();
    password.dispose();
    role.dispose();

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
          decoration: decorationForTextFormField('User name'),
          onChanged: (val) {
            username.text = val;
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
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Full name'),
          onChanged: (val) {
            fullName.text = val;
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
          decoration: decorationForTextFormField('Role'),
          onChanged: (val) {
            role.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          items: [...rolesOfTheUser].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          // value: types[0],
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
