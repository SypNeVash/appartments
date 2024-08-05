import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../../../constans/app_constants.dart';

class RemoteClientApi {
  final Dio _dio = Dio();

  Future<ApartmentModelList> fetchClientDataFromDB(int page, int limit,
      {String? filter}) async {
    var url = '$URL/api/RentObjects/pagination';
    late ApartmentModelList apartmentModelList;
    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      Map<String, dynamic> queryParameters = {
        'page': page,
        'count': limit,
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
      apartmentModelList = ApartmentModelList.fromJson(data);

      return apartmentModelList;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<bool> deleteClientDataFromDB(
    String clientId,
  ) async {
    var url = '$URL/api/CustomerCards/$clientId';

    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

      Response response = await _dio.delete(
        url,
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
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<void> updateField(String id, String newContactPerson) async {
    Dio dio = Dio();

    try {
      // Define the URL for the PATCH request
      String url = 'https://api.example.com/data/$id';

      // Define the data to be sent in the request body
      Map<String, dynamic> data = {
        'contactPerson': newContactPerson,
      };

      // Send the PATCH request
      Response response = await dio.patch(url, data: data);

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print('Error updating field: $e');
    }
  }
}
