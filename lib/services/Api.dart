// ignore_for_file: file_names

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'userInfo.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: data, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode :${response.statusCode}');
    }
  }
}