// ignore_for_file: file_names, camel_case_types, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:AKHIS/api/Api.dart';
import 'package:AKHIS/api/apiUrl.dart';
import 'package:AKHIS/models/ReadUpdateDeleteUserModel.dart';
import 'package:http/http.dart' as http;

class rudUserService {
  static const String _baseUrl = 'http://192.168.43.220:8000';
  static getUrl() {
    return _baseUrl;
  }

  static Future<List<ReadUserModel>> GetReadUserService() async {
    try {
      final response = await http.get(Uri.parse(apiUrl.user));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final parsed = json = json.cast<Map<String, dynamic>>();
        return parsed
            .map<ReadUserModel>((json) => ReadUserModel.fromJson(json))
            .toList();
      } else {
        // throw Exception("gagal load data");
        return [];
      }
    } catch (e) {
      // print(e.toString());
      return [];
    }
  }

  static Future PutUpdateUserService({UserUpdateModel? user}) async {
    String api_Url = apiUrl.updateUser(user!.id!);

    var body = {
      "nama": user.nama,
      "email": user.email,
      "alamat": user.alamat,
      "role": user.role,
      "jenisKelamin": user.jenisKelamin,
      "foto": user.foto
    };

    var response = await Api().put(api_Url, body);
    var jsonObj = json.decode(response.body);
    if (jsonObj['code'] == 200) {
      return UserUpdateModel.success(jsonObj);
    } else {
      return UserUpdateModel.error(jsonObj);
    }
  }

  static Future GetDeleteUserService(id) async {
    String api_Url = apiUrl.deleteUser(id);
    var response = await Api().delete(api_Url);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // void dispose() {}
}
