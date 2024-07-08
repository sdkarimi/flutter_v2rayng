import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_v2y/data/Appinfo.dart';
import 'package:flutter_v2y/data/common/http_response_validator.dart';

abstract class IAppDataSource {
  Future<AppInfo> getInfo();

}


class AppRemoteDataSource with HttpResponseValidator implements IAppDataSource {
  final Dio httpClient;

  AppRemoteDataSource(this.httpClient);

  @override
  Future<AppInfo> getInfo() async {
    final response = await httpClient.get('settings/index.php');
    validateResponse(response);

    if (response.data['status'] == 'ok') {
      final result = response.data['result'];
      return AppInfo.fromJson(result);
    } else {
      throw Exception('Unexpected response format');
      // return ;
    }
  }




}