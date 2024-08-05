import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/utils/services/apartment_image_service.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TextFormForAddingEditingApt extends StatefulWidget {
  const TextFormForAddingEditingApt({Key? key}) : super(key: key);

  @override
  State<TextFormForAddingEditingApt> createState() =>
      _TextFormForAddingEditingAptState();
}

class _TextFormForAddingEditingAptState
    extends State<TextFormForAddingEditingApt> {
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
  final TextEditingController status = TextEditingController();
  DateTime now = DateTime.now();
  ApartmentModel apartmentModel = ApartmentModel();
  ApiClient apiClient = ApiClient();

  Future<bool> postDataFOrEditing() async {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    final Dio _dio = Dio();
    final id = await SPHelper.getIDAptSharedPreference() ?? '';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    List listOfImages = [];
    final List<dynamic> listFromModelPhoto =
        profileDetailsListener.getAllPortfolioImagesWithNotifier;
    String url = '$URL/api/RentObjects/$id';
    List<dynamic> mergedList = [];
    try {
      if (profileDetailsListener.getXfileList.isNotEmpty &&
          listFromModelPhoto.isEmpty) {
        listOfImages = await ApiClient().sendImages(context, accessToken, id);
        mergedList = listOfImages;
      }
      if (listFromModelPhoto.isNotEmpty &&
          profileDetailsListener.getXfileList.isNotEmpty) {
        final listOfImage =
            await ApiClient().sendImages(context, accessToken, id);
        mergedList = [...listOfImage, ...listFromModelPhoto];
      } else if (profileDetailsListener.getXfileList.isEmpty &&
          listFromModelPhoto.isNotEmpty) {
        mergedList = listFromModelPhoto;
      } else if (listFromModelPhoto.isEmpty &&
          profileDetailsListener.getXfileList.isEmpty) {
        mergedList = [];
      }

      Map<String, dynamic> data = {
        "id": id,
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
        "status": status.text,
        "createdData": now.toString(),
        "updatedUser": now.toString(),
        "photos": mergedList,
      };

      final response = await _dio.put(
        url,
        data: data,
        options: Options(
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

  List<dynamic>? apartmentPhotos = [];
  String? selectedType;
  String? selectedCity;
  String? selectedRegion;
  String? selectedStatus;
  getApartmentDetails() async {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    apartmentModel = await apiClient.fetchApartmentDetails();
    contactPerson.text = apartmentModel.contactPerson.toString();
    address.text = apartmentModel.address.toString();
    region.text = apartmentModel.region.toString();
    selectedRegion = apartmentModel.region.toString();
    status.text = apartmentModel.status.toString();
    selectedStatus = apartmentModel.status.toString();
    city.text = apartmentModel.city.toString();
    selectedCity = apartmentModel.city.toString();
    square.text = apartmentModel.square.toString();
    price.text = apartmentModel.price.toString();
    type.text = apartmentModel.type.toString();
    selectedType = apartmentModel.type.toString();
    description.text = apartmentModel.description.toString();
    comments.text = apartmentModel.comment.toString();
    phone.text = apartmentModel.phone.toString();
    floor.text = apartmentModel.floor.toString();
    maxFloor.text = apartmentModel.maxFloor.toString();
    profileDetailsListener.setAllPortfolioImagesWithNotifier =
        apartmentModel.photos;
    setState(() {});
  }

  @override
  void initState() {
    getApartmentDetails();

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
    status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: contactPerson,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,

          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Контактна особа'),
          // onChanged: (val) {
          //   contactPerson.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: address,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Адреса'),
          // onChanged: (val) {
          //   address.text = val;
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
          hint: const Text('Status'),
          items: statuses.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedStatus ?? statuses[0],
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
          hint: const Text('Місто'),
          items: cities.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedCity ?? cities[0],
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
          hint: const Text('Район'),
          items: regions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedRegion ?? regions[0],
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: square,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Площа'),
          // onChanged: (val) {
          //   square.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: price,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Ціна ₴'),
          // onChanged: (val) {
          //   price.text = val;
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
          decoration: decorationForTextFormField('Тип'),
          onChanged: (val) {
            type.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          hint: const Text('Тип'),
          items: types.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: selectedType ?? types[0],
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: description,
          maxLines: 5,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Опис'),
          // onChanged: (val) {
          //   description.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: floor,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Поверх'),
          // onChanged: (val) {
          //   floor.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: maxFloor,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Максимальний поверх'),
          // onChanged: (val) {
          //   floor.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: phone,
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
          controller: comments,
          maxLines: 3,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Коментарій'),
          onChanged: (val) {
            comments.text = val;
          },
        ),
        const SizedBox(
          height: 55,
        ),
        ChooseImageForAppartment(apartmentModel.photos),
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
                final done = await postDataFOrEditing();
                if (done == true) {
                  cancel();
                  Navigator.of(context).pop();
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
