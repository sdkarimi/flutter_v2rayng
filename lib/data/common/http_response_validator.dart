import 'package:dio/dio.dart';
import 'package:flutter_v2y/common/exceptions.dart';

mixin HttpResponseValidator{
  validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}