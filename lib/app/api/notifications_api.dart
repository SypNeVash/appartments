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
}
