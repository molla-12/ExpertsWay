import 'package:dio/dio.dart';
import 'package:learncoding/models/course.dart';
import 'package:learncoding/utils/constants.dart';

class ApiProvider {
  Future<Course> retrieveCourses() async {
    var dio = Dio();
    Response response = await dio.get(AppUrl.courseUrl);
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final courses = courseFromJson(responseBody);

      return courses;
    } else {
      throw Exception('Failed to load course');
    }
  }
}
