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
  final String apiUrl = 'https://realtor.azurewebsites.net/api/RentObjects';
  final TextEditingController contactPerson = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController region = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController floor = TextEditingController();
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
    String url = 'https://realtor.azurewebsites.net/api/RentObjects/$id';
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
        "postalCode": postalCode.text,
        "price": price.text,
        "type": type.text,
        "description": description.text,
        "comment": comments.text,
        "phone": phone.text,
        "floor": floor.text,
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
    postalCode.text = apartmentModel.postalCode.toString();
    price.text = apartmentModel.price.toString();
    type.text = apartmentModel.type.toString();
    selectedType = apartmentModel.type.toString();
    description.text = apartmentModel.description.toString();
    comments.text = apartmentModel.comment.toString();
    phone.text = apartmentModel.phone.toString();
    floor.text = apartmentModel.floor.toString();
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
    postalCode.dispose();
    address.dispose();
    price.dispose();
    type.dispose();
    description.dispose();
    comments.dispose();
    phone.dispose();
    floor.dispose();
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
          decoration: decorationForTextFormField('Contact Person'),
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
          decoration: decorationForTextFormField('Address'),
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
          decoration: decorationForTextFormField('Status'),
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
          decoration: decorationForTextFormField('City'),
          onChanged: (val) {
            city.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          hint: const Text('City'),
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
          decoration: decorationForTextFormField('Region'),
          onChanged: (val) {
            region.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          hint: const Text('Region'),
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
          controller: postalCode,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Postal Code'),
          // onChanged: (val) {
          //   postalCode.text = val;
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
          decoration: decorationForTextFormField('Price',
              icon: const FaIcon(
                FontAwesomeIcons.dollarSign,
                color: Colors.grey,
              )),
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
          decoration: decorationForTextFormField('Type'),
          onChanged: (val) {
            type.text = val!;
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            size: 15,
            color: Colors.grey,
          ),
          hint: const Text('Type'),
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
          decoration: decorationForTextFormField('Description'),
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
          decoration: decorationForTextFormField('Floor'),
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
          decoration: decorationForTextFormField('Phone'),
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
          decoration: decorationForTextFormField('Comments'),
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
