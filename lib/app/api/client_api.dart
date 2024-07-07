import 'dart:convert';
import 'dart:typed_data';
import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customers_model.dart';

class ApiClient {
  final Dio _dio = Dio();

  // Future<dynamic> registerUser(Map<String, dynamic>? data) async {
  //   try {
  //     Response response = await _dio.post(
  //         'auth/register',
  //         data: data,
  //         // queryParameters: {'apikey': ApiSecret.apiKey},
  //         options: Options(headers: {'X-LoginRadius-Sott': ApiSecret.sott}));
  //     return response.data;
  //   } on DioError catch (e) {
  //     return e.response!.data;
  //   }
  // }

  Future<String> getToken() async {
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    return accessToken;
  }

  Future<dynamic> getUserProfileData(String accessToken) async {
    try {
      Response response = await _dio.get(
        'https://realtor.azurewebsites.net/api/CustomerCards',
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> updateUserProfile({
    required String accessToken,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await _dio.put(
        'https://api.loginradius.com/identity/v2/auth/account',
        data: data,
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> logout() async {
    final accessToken = await SPHelper.removeTokenSharedPreference();

    return accessToken;

    //   try {
    //     Response response = await _dio.get(
    //       'https://api.loginradius.com/identity/v2/auth/access_token/InValidate',
    //       // queryParameters: {'apikey': ApiSecret.apiKey},
    //       options: Options(
    //         headers: {'Authorization': 'Bearer $accessToken'},
    //       ),
    //     );
    //     return response.data;
    //   } on DioError catch (e) {
    //     return e.response!.data;
    //   }
    // }
  }

  Future<ApartmentModel> fetchApartmentDetails() async {
    String apartmentId = await SPHelper.getIDAptSharedPreference() ?? '';
    var url = 'https://realtor.azurewebsites.net/api/RentObjects/$apartmentId';
    late ApartmentModel apartmentModel;

    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    try {
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;
      apartmentModel = ApartmentModel.fromJsonToMap(data);
      return apartmentModel;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<List<dynamic>> sendImages(
      BuildContext context, String _jwtToken, String id) async {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    late List<dynamic> photoReferences;
    String url = 'https://realtor.azurewebsites.net/api/Files/$id';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $_jwtToken';

      for (XFile file in profileDetailsListener.getXfileList) {
        Uint8List fileBytes = await file.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'files',
          fileBytes,
          filename: basename(file.path),
        );

        request.files.add(multipartFile);
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        photoReferences = json.decode(responseData);
      } else {}
    } catch (e) {
      print('Upload error: $e');
    }
    return photoReferences;
  }

  Future<CustomerModelList> fetchClientDataFromAzure(int page,
      {String? filter}) async {
    var url = 'https://realtor.azurewebsites.net/api/CustomerCards/pagination';
    late CustomerModelList customerModelList;
    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      Map<String, dynamic> queryParameters = {
        'page': page,
        'count': 10,
      };
      // if (filter != null && filter.isNotEmpty) {
      //   queryParameters['filter'] = filter;
      // }
      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;

      customerModelList = CustomerModelList.fromJsons(data);
      return customerModelList;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  static Future<CustomerModelList> searchClients(
      List<FilterCondition> filters, page) async {
    var url =
        'https://realtor.azurewebsites.net/api/CustomerCards/paginationWithFilter';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

    var filterJson = jsonEncode(filters);
    try {
      Map<String, dynamic> queryParameters = {
        'page': page,
        'count': 10,
        'conditions': filterJson
      };
      // for (var filter in filters) {
      //   queryParameters["property"] = filter.property;
      //   queryParameters['value'] = filter.value;
      //   queryParameters['condition'] = filter.condition;
      // }

      for (int i = 0; i < filters.length; i++) {
        queryParameters['conditions[$i].property'] = filters[i].property;
        queryParameters['conditions[$i].value'] = filters[i].value;
        queryParameters['conditions[$i].condition'] = filters[i].condition;
      }

      final response = await Dio().get(url,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          queryParameters: queryParameters);

      final data = response.data;
      return CustomerModelList.fromJsons(data);
    } catch (e) {
      throw Exception('Failed to search apartments: $e');
    }
  }

  Future<CustomerModel> fetchClientDataById() async {
    final id = await SPHelper.getClientsIDSharedPreference() ?? '';
    var url = 'https://realtor.azurewebsites.net/api/CustomerCards/$id';
    late CustomerModel customerModel;

    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;

      customerModel = CustomerModel.fromJsonToMap(data);

      return customerModel;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
