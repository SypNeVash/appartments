import 'package:apartments/app/models/task_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';

class TaskApi {
  Dio dio = Dio();

  Future<List<TaskModel>> fetchTasks() async {
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    var url = 'https://realtor.azurewebsites.net/api/Task';
    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      List<dynamic> data = response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<bool> tasksDone(String idTask) async {
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    var url = 'https://realtor.azurewebsites.net/api/Task/done';

    final data = {
      'id': idTask,
    };

    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      print("responseis: $response");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('Error: ${e.response?.data}');
      return false;
    }
  }
}
