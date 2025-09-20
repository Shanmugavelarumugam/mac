import 'package:btc_f/utils/constants.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Dio dio = Dio(BaseOptions(baseUrl: '$baseUrl/users'));

  Future<User> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    return User.fromJson(response.data);
  }

  Future<User> signup(String name, String email, String password) async {
    final response = await dio.post(
      '/signup',
      data: {'name': name, 'email': email, 'password': password},
    );
    return User.fromJson(response.data);
  }
}
