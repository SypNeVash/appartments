import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';

class WorkAreApi {
  final Dio _dio = Dio();

  Future<WorkingAreaModelList> fetchWorkinAreData(
    int page,
  ) async {
    var url = 'https://realtor.azurewebsites.net/api/WorkArea/pagination';
    late WorkingAreaModelList workingAreaModelList;
    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      Map<String, dynamic> queryParameters = {
        'page': page,
        'count': 10,
      };

      print('started');

      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;

      workingAreaModelList = WorkingAreaModelList.fromJson(data);

      return workingAreaModelList;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  // static Future<ApartmentModelList> searchApartments(
  //     List<FilterCondition> filters, page) async {
  //   var url =
  //       'https://realtor.azurewebsites.net/api/RentObjects/paginationWithFiler';
  //   final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

  //   var filterJson = jsonEncode(filters);
  //   try {
  //     Map<String, dynamic> queryParameters = {
  //       'page': page,
  //       'count': 10,
  //       'conditions': filterJson
  //     };
  //     // for (var filter in filters) {
  //     //   queryParameters["property"] = filter.property;
  //     //   queryParameters['value'] = filter.value;
  //     //   queryParameters['condition'] = filter.condition;
  //     // }

  //     for (int i = 0; i < filters.length; i++) {
  //       queryParameters['conditions[$i].property'] = filters[i].property;
  //       queryParameters['conditions[$i].value'] = filters[i].value;
  //       queryParameters['conditions[$i].condition'] = filters[i].condition;
  //     }

  //     final response = await Dio().get(url,
  //         options: Options(
  //           headers: {'Authorization': 'Bearer $accessToken'},
  //         ),
  //         queryParameters: queryParameters);

  //     final data = response.data;
  //     return ApartmentModelList.fromJson(data);
  //   } catch (e) {
  //     throw Exception('Failed to search apartments: $e');
  //   }
  // }

  // Future<bool> deleteApartDataFromAzure(
  //   String apartmentId,
  // ) async {
  //   var url = 'https://realtor.azurewebsites.net/api/RentObjects/$apartmentId';

  //   try {
  //     final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

  //     Response response = await _dio.delete(
  //       url,
  //       options: Options(
  //         headers: {'Authorization': 'Bearer $accessToken'},
  //       ),
  //     );
  //     // final data = response.data;
  //     if (response.statusCode == 200 ||
  //         response.statusCode == 201 ||
  //         response.statusCode == 204) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } on DioError catch (e) {
  //     return e.response!.data;
  //   }
  // }

  // Future deleteImageFromAppartment(String apartmentId, String photoUrl) async {
  //   var url = 'https://realtor.azurewebsites.net/api/RentObjects/$apartmentId';

  //   try {
  //     final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

  //     Response response = await _dio.patch(
  //       url,
  //       options: Options(
  //         headers: {'Authorization': 'Bearer $accessToken'},
  //       ),
  //     );
  //     // final data = response.data;
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //     } else {}
  //     return true;
  //   } on DioError catch (e) {
  //     return e.response!.data;
  //   }
  // }
}
