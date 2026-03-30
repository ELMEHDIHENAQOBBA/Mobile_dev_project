import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/config/app_config.dart';
import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/login',
          data: {'email': email, 'password': password});
      final data = response.data['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.tokenKey, data['token'] as String);
      return _userFromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleError(e);
    }
    throw Exception('sign-in-failed');
  }

  @override
  Future<UserModel> signUp({required String email, required String password, required String name}) async {
    try {
      final response = await _dio.post('/auth/register',
          data: {'email': email, 'password': password, 'name': name});
      final data = response.data['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.tokenKey, data['token'] as String);
      return _userFromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleError(e);
    }
    throw Exception('sign-up-failed');
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userKey);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey) != null ? null : null;
  }

  UserModel _userFromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'].toString(),
        email: json['email'] as String,
        name: json['name'] as String,
        photoUrl: json['photoUrl'] as String?,
      );

  Never _handleError(DioException e) {
    final msg = e.response?.data?['message']?.toString() ?? '';
    if (e.response?.statusCode == 401 || msg.contains('Invalid')) {
      throw Exception('invalid-credentials');
    }
    if (e.response?.statusCode == 409 || msg.contains('already')) {
      throw Exception('email-already-in-use');
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      throw Exception('network-error');
    }
    throw Exception('server-error');
  }
}
