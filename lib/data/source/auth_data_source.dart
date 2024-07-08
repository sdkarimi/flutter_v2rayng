import 'package:dio/dio.dart';
import 'package:flutter_v2y/data/auth_info.dart';
import 'package:flutter_v2y/data/common/http_response_validator.dart';

abstract class IAuthDataSource {
  Future<dynamic> login(String username, String password);

  Future<dynamic> signUp(String username, String password);

  Future<dynamic> refreshToken(String token);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);

  @override
  Future<dynamic> login(String username, String password) async {
    final response = await httpClient.post("auth/token", data: {
    });

    validateResponse(response);

    return AuthInfo(
        response.data["access_token"]);
  }

  @override
  Future<dynamic> refreshToken(String token) async {
    final response = await httpClient.post("auth/token", data: {

    });

    validateResponse(response);

    return AuthInfo(
        response.data["access_token"]);
  }

  @override
  Future<dynamic> signUp(String username, String password) async {
    final response = await httpClient
        .post("user/register", data: {"email": username, "password": password});
    validateResponse(response);
    return login(username, password);
  }
}
