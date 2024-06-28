import 'dart:convert';

import 'package:apartments/app/models/admin_panel_model.dart';
import 'package:apartments/app/providers/admin_panel_provider.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';

class AdminPanelApi {
  final Dio _dio = Dio();

  Future<AdminPanelModelList> fetchAdminPanelData(
    int page,
  ) async {
    var url =
        'https://realtor.azurewebsites.net/api/Authenticate/paginationWithFilter';
    late AdminPanelModelList adminPanelModelList;
    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      Map<String, dynamic> queryParameters = {
        'page': page,
        'count': 10,
      };

      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;

      adminPanelModelList = AdminPanelModelList.fromJson(data);

      return adminPanelModelList;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  static Future<AdminPanelModelList> searchApartments(
      List<FilterCondition> filters, page) async {
    var url =
        'https://realtor.azurewebsites.net/api/RentObjects/paginationWithFiler';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

    var filterJson = jsonEncode(filters);
    try {
      Map<String, dynamic> queryParameters = {
        'page': page,
        'count': 10,
        'conditions': filterJson
      };

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
      return AdminPanelModelList.fromJson(data);
    } catch (e) {
      throw Exception('Failed to search apartments: $e');
    }
  }

  Future<bool> deleteAdminPanelItems(
    String userName,
  ) async {
    var url =
        'https://realtor.azurewebsites.net/api/Authenticate?userName=$userName';

    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

      Response response = await _dio.delete(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      // final data = response.data;
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
