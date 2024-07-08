import 'package:dio/dio.dart';
import 'package:flutter_v2y/data/common/http_response_validator.dart';

abstract class IConfigDataSource {
  Future<List<dynamic>> getAll();

}


class ConfigRemoteDataSource with HttpResponseValidator implements IConfigDataSource {
  final Dio httpClient;

  ConfigRemoteDataSource(this.httpClient);

  @override
  Future<List<dynamic>> getAll() async {
    final response = await httpClient.get('servers/show.php');
    validateResponse(response);


    if (response.data['status'] == 'ok' && response.data['result'] is List) {
      return response.data['result'];
    } else {
      throw Exception('Unexpected response format');
    }
  }




}