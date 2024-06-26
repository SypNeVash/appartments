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

  Future<bool> postWorkAreaClient(jsonData) async {
    Dio dio = Dio();
    String apiUrl = 'https://realtor.azurewebsites.net/api/WorkArea';
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

    Response response = await dio.post(
      apiUrl,
      data: jsonData,
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
  }

  Future<bool> editWorkAreaClient(String jsonData) async {
    Dio dio = Dio();
    final workAreaId = await SPHelper.getWorkAreaIDSharedPreference();
    final accessToken = await SPHelper.getTokenSharedPreference();

    if (workAreaId == null || accessToken == null) {
      print('Error: Missing workAreaId or accessToken');
      return false;
    }

    String apiUrl =
        'https://realtor.azurewebsites.net/api/WorkArea/$workAreaId';

    try {
      Response response = await dio.put(
        apiUrl,
        data: jsonData,
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

  Future<WorkingAreaModel> fetchWorkingAreaDetailsById() async {
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    late WorkingAreaModel workingAreaModel;
    final workAreaId = await SPHelper.getWorkAreaIDSharedPreference();
    var url = 'https://realtor.azurewebsites.net/api/WorkArea/$workAreaId';
    try {
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final dataFromResponse = response.data;
      workingAreaModel = WorkingAreaModel.fromJsonToMap(dataFromResponse);
      return workingAreaModel;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<bool> deleteWorkAre(
    String workAreId,
  ) async {
    var url = 'https://realtor.azurewebsites.net/api/WorkArea/$workAreId';

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
