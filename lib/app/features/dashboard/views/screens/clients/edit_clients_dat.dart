import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/providers/clients_provider.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditClientsData extends StatefulWidget {
  const EditClientsData({super.key});

  @override
  State<EditClientsData> createState() => _EditClientsDataState();
}

class _EditClientsDataState extends State<EditClientsData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: const Column(
              children: [
                FormsEditClientList(),
                TextFormForEditingClient(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormsEditClientList extends StatelessWidget {
  const FormsEditClientList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Customer',
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

class TextFormForEditingClient extends StatefulWidget {
  const TextFormForEditingClient({Key? key}) : super(key: key);

  @override
  State<TextFormForEditingClient> createState() =>
      _TextFormForEditingClientState();
}

class _TextFormForEditingClientState extends State<TextFormForEditingClient> {
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
  String errorText = '';
  CustomerModel customerModel = CustomerModel();

  Future<bool> postClientData() async {
    Dio dio = Dio();
    final id = await SPHelper.getClientsIDSharedPreference() ?? '';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    String apiUrl = 'https://realtor.azurewebsites.net/api/CustomerCards/$id';
    print(id);
    try {
      Map<String, String> datas = {
        "id": id,
        "name": name.text,
        "surname": surname.text,
        "patronymic": patronymic.text,
        "passport": passport.text,
        "phoneNumber": phoneNumber.text,
        "address": address.text,
        "birthday": birthday.text,
        "username": username.text,
        "password": password.text,
        "email": email.text,
        "role": role.text
      };
      Response response = await dio.put(
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
    } catch (e) {
      return false;
    }
  }

  var rolesOfClient = [
    "Recall",
    "Meet",
    "Inprogress",
    "Finished",
    "Freezed",
    "Returned",
    "Realtor"
  ];
  String? selectedRole;
  getDataByID() async {
    customerModel = await ApiClient().fetchClientDataById();
    name.text = customerModel.name.toString();
    surname.text = customerModel.surname.toString();
    patronymic.text = customerModel.patronymic.toString();
    passport.text = customerModel.passport.toString();
    phoneNumber.text = customerModel.phoneNumber.toString();
    address.text = customerModel.address.toString();
    birthday.text = customerModel.birthday.toString();
    username.text = customerModel.username.toString();
    email.text = customerModel.email.toString();
    role.text = customerModel.role.toString();
    selectedRole = customerModel.role.toString();
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
  void initState() {
    getDataByID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: name,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Name'),
          // onChanged: (val) {
          //   name.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: surname,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Surname'),
          // onChanged: (val) {
          //   surname.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: patronymic,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Patronymic'),
          // onChanged: (val) {
          //   patronymic.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: passport,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Passport'),
          // onChanged: (val) {
          //   passport.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: phoneNumber,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Phone Number'),
          // onChanged: (val) {
          //   phoneNumber.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: address,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField(
            'Address',
          ),
          // onChanged: (val) {
          //   address.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: birthday,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Birthday'),
          // onChanged: (val) {
          //   birthday.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: password,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Password'),
          // onChanged: (val) {
          //   password.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: username,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Username'),
          // onChanged: (val) {
          //   username.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: email,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Email'),
          // onChanged: (val) {
          //   email.text = val;
          // },
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
          items: rolesOfClient.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedRole ?? rolesOfClient[0],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          errorText,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
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

                  Provider.of<ClientProvider>(context, listen: false)
                      .fetchClients(1);

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
