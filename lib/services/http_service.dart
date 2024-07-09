import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/department_model.dart';

import '../model/employee_model.dart';
import '../model/group_model.dart';
import '../model/history_model.dart';

class HttpService {
  static String currentUri = Uri.base.toString();
  static String isSecured = currentUri.substring(4, 5);

  static const String _serverUrlHttp = 'http://103.62.153.74:53000/';
  String get serverUrlHttp => _serverUrlHttp;

  static const String _serverUrlHttps = 'https://konek.parasat.tv:50443/dtr/';
  String get serverUrlHttps => _serverUrlHttps;

  static final String _url =
      isSecured == 's' ? _serverUrlHttps : _serverUrlHttp;

  static final String _serverUrl = '${_url}dtr_history_api';
  static String get serverUrl => _serverUrl;

  // static const String _serverUrl = 'http://103.62.153.74:53000/dtr_history_api';
  // static String get serverUrl => _serverUrl;

  //http://103.62.153.74:53000/field_api/images/02222/20240116091536.jpg

  static Future<List<HistoryModel>> getRecords({
    required String employeeId,
    required String dateFrom,
    required String dateTo,
    required DepartmentModel department,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_history.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'employee_id': employeeId,
              'date_from': dateFrom,
              'date_to': dateTo,
              'department': department.departmentId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint('getRecords ${response.body}');
    return historyModelFromJson(response.body);
  }

  static Future<List<HistoryModel>> getRecordsAll({
    required String dateFrom,
    required String dateTo,
    required DepartmentModel department,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_history_all.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'date_from': dateFrom,
              'date_to': dateTo,
              'department': department.departmentId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    return historyModelFromJson(response.body);
  }

  static Future<List<DepartmentModel>> getDepartment() async {
    var response = await http.get(
      Uri.parse('$_serverUrl/get_department.php'),
      headers: <String, String>{
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    return departmentModelFromJson(response.body);
  }

  static Future<List<EmployeeModel>> getEmployee(String departmentId) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_employee.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{
            "department_id": departmentId,
          }),
        )
        .timeout(const Duration(seconds: 10));
    return employeeModelFromJson(response.body);
  }

  static Future<List<EmployeeModel>> searchEmployee({
    required String employeeId,
    required String departmentId,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/search_employee.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{
            "employee_id": employeeId,
            "department_id": departmentId,
          }),
        )
        .timeout(const Duration(seconds: 10));
    return employeeModelFromJson(response.body);
  }

  static Future<void> addGroup({
    required List<String> employeeId,
    required String groupName,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/add_new_group.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{
            "employee_id": employeeId,
            "group_name": groupName,
          }),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint('${response.statusCode} ${response.body}');
  }

  static Future<List<GroupModel>> getGroup() async {
    var response = await http.get(
      Uri.parse('$_serverUrl/get_group.php'),
      headers: <String, String>{
        'Accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    return groupModelFromJson(response.body);
  }

  static Future<List<EmployeeModel>> getEmployeeGroup(String groupId) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_employee_group.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, dynamic>{
            "group_id": groupId,
          }),
        )
        .timeout(const Duration(seconds: 10));
    return employeeModelFromJson(response.body);
  }

  static Future<List<HistoryModel>> getGroupRecords({
    required String dateFrom,
    required String dateTo,
    required GroupModel group,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_history_group.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'date_from': dateFrom,
              'date_to': dateTo,
              'group_id': group.id.toString(),
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    // debugPrint('getGroupRecords ${response.statusCode} ${response.body}');
    return historyModelFromJson(response.body);
  }

  static Future<void> editGroup({
    required GroupModel group,
    required List<String> employeeIdNew,
    required List<String> employeeIdRemove,
    required int updateGroupName,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/edit_group.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'id': group.id,
              'group_id': group.id,
              'group_name': group.groupName,
              'employee_id_new': employeeIdNew,
              'employee_id_remove': employeeIdRemove,
              'update_group_name': updateGroupName,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint('editGroup ${response.statusCode} ${response.body}');
  }

  static Future<void> deleteGroup({required GroupModel group}) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/delete_group.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'id': group.id,
              'group_id': group.id.toString(),
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint('deleteGroup ${response.statusCode} ${response.body}');
  }

  static Future<List<HistoryModel>> getRecordsAllApprovedSelfies({
    required String dateFrom,
    required String dateTo,
    required DepartmentModel department,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_history_all_approved_selfies.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'date_from': dateFrom,
              'date_to': dateTo,
              'department': department.departmentId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint("getRecordsAllApproved ${response.body}");
    return historyModelFromJson(response.body);
  }

  static Future<List<HistoryModel>> getRecordsApprovedSelfies({
    required String employeeId,
    required String dateFrom,
    required String dateTo,
    required DepartmentModel department,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_history_approved_selfies.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'employee_id': employeeId,
              'date_from': dateFrom,
              'date_to': dateTo,
              'department': department.departmentId,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint('getRecordsApprovedSelfies ${response.body}');
    return historyModelFromJson(response.body);
  }

  static Future<List<HistoryModel>> getGroupRecordsApprovedSelfies({
    required String dateFrom,
    required String dateTo,
    required GroupModel group,
  }) async {
    var response = await http
        .post(
          Uri.parse('$_serverUrl/get_history_group_approved_selfies.php'),
          headers: <String, String>{
            'Accept': '*/*',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              'date_from': dateFrom,
              'date_to': dateTo,
              'group_id': group.id.toString(),
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    debugPrint('getGroupRecordsApproved ${response.body}');
    return historyModelFromJson(response.body);
  }
}
