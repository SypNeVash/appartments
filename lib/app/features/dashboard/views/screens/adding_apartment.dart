import 'dart:convert';
import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/utils/services/apartment_image_service.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddingNewApartments extends StatelessWidget {
  final Function? onPressedMenu;
  const AddingNewApartments({this.onPressedMenu, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        // Use Row layout if screen width is greater than 600 pixels
        return const Row(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(top: 28.0),
                child: Column(
                  children: [FormsList(), TextFormForAddingNewApt()],
                ),
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
          ],
        );
      } else {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [FormsList(), TextFormForAddingNewApt()],
          ),
        );
      }
    });
  }
}

class FormsList extends StatelessWidget {
  const FormsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
          'Додати новий апартамент',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
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

class TextFormForAddingNewApt extends StatefulWidget {
  const TextFormForAddingNewApt({Key? key}) : super(key: key);

  @override
  State<TextFormForAddingNewApt> createState() =>
      _TextFormForAddingNewAptState();
}

class _TextFormForAddingNewAptState extends State<TextFormForAddingNewApt> {
  final String apiUrl = '$URL/api/RentObjects';
  final TextEditingController contactPerson = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController region = TextEditingController();
  final TextEditingController square = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController floor = TextEditingController();
  final TextEditingController maxFloor = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController comments = TextEditingController();
  DateTime now = DateTime.now();

  Future<bool> postData() async {
    try {
      String uuid = const Uuid().v4();
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      final listOfImages =
          await ApiClient().sendImages(context, accessToken, uuid);
      final response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode(
            <String, dynamic>{
              "id": uuid,
              "contactPerson": contactPerson.text,
              "address": address.text,
              "city": city.text,
              "region": region.text,
              "square": square.text,
              "price": price.text,
              "type": type.text,
              "description": description.text,
              "comment": comments.text,
              "phone": phone.text,
              "floor": floor.text,
              "maxFloor": maxFloor.text,
              "status": "Active",
              "createdData": now.toString(),
              "updatedUser": now.toString(),
              "photos": listOfImages,
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
    super.initState();
  }

  @override
  void dispose() {
    city.dispose();
    region.dispose();
    contactPerson.dispose();
    square.dispose();
    address.dispose();
    price.dispose();
    type.dispose();
    description.dispose();
    comments.dispose();
    phone.dispose();
    floor.dispose();
    maxFloor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppartDetailsListener>(context, listen: true);
    return Column(
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Контактна особа'),
          onChanged: (val) {
            contactPerson.text = val;
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
          decoration: decorationForTextFormField('Адреса'),
          onChanged: (val) {
            address.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: false,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Місто'),
          onChanged: (val) {
            city.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          items: cities.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          // value: cities[0],
        ),
        const SizedBox(
          height: 15,
        ),
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.always,
          autofocus: false,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Район'),
          onChanged: (val) {
            region.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          items: regions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          // value: regions[0],
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
          decoration: decorationForTextFormField('Площа'),
          onChanged: (val) {
            square.text = val;
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
          decoration: decorationForTextFormField('Ціна ₴'),
          onChanged: (val) {
            price.text = val;
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
          decoration: decorationForTextFormField('Тип'),
          onChanged: (val) {
            type.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          items: types.map((String value) {
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
          maxLines: 5,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Опис'),
          onChanged: (val) {
            description.text = val;
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
          decoration: decorationForTextFormField('Поверх'),
          onChanged: (val) {
            floor.text = val;
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
          decoration: decorationForTextFormField('Поверховість'),
          onChanged: (val) {
            maxFloor.text = val;
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
          decoration: decorationForTextFormField('Телефон'),
          onChanged: (val) {
            phone.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLines: 3,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Коментар'),
          onChanged: (val) {
            comments.text = val;
          },
        ),
        const SizedBox(
          height: 55,
        ),
        const ChooseImageForAppartment(null),
        const SizedBox(
          height: 55,
        ),
        // ignore: sized_box_for_whitespace
        Container(
          width: 250,
          height: 40,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 188, 2),
              ),
              onPressed: () async {
                var cancel = BotToast.showLoading();
                final done = await postData();
                cancel();
                if (done == true) {
                  provider.setPageIndex = 0;
                }
                else {
                  showSnackBarForError();
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
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
  
  showSnackBarForError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        content: Text('Помилка при відправці. Спробуйте ще раз'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
textShow() {
  return const Text('dddd');
}
