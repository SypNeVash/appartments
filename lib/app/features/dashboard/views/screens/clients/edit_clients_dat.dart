import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/providers/clients_provider.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Редагувати клієнта',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'Будь ласка, заповніть форму',
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
  final TextEditingController passport = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController status = TextEditingController();
  final TextEditingController comments = TextEditingController();

  String errorText = '';
  CustomerModel customerModel = CustomerModel();

  Future<bool> postClientData() async {
    Dio dio = Dio();
    final id = await SPHelper.getClientsIDSharedPreference() ?? '';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    String apiUrl = 'https://realtor.azurewebsites.net/api/CustomerCards/$id';

    try {
      Map<String, String> datas = {
        "id": id,
        "name": name.text,
        "passport": passport.text,
        "phoneNumber": phoneNumber.text,
        "status": status.text,
        "comment": comments.text
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

  String? selectedRole;
  getDataByID() async {
    customerModel = await ApiClient().fetchClientDataById();
    name.text = customerModel.name.toString();
    passport.text = customerModel.passport.toString();
    phoneNumber.text = customerModel.phoneNumber.toString();
    selectedRole = customerModel.status.toString();
    status.text = customerModel.status.toString();
    comments.text = customerModel.comment.toString();
    setState(() {});
  }

  @override
  void dispose() {
    name.dispose();
    passport.dispose();
    phoneNumber.dispose();
    comments.dispose();
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
          decoration: decorationForTextFormField("Ім'я"),
          // onChanged: (val) {
          //   name.text = val;
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
          decoration: decorationForTextFormField('Паспорт'),
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
          decoration: decorationForTextFormField('Телефон'),
          // onChanged: (val) {
          //   phoneNumber.text = val;
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
          decoration: decorationForTextFormField('Статус'),
          onChanged: (val) {
            status.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          hint: const Text('Статус'),
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
        Text(
          errorText,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
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
                'Зберегти',
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
