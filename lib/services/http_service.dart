import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/department_model.dart';

import '../model/employee_model.dart';
import '../model/group_model.dart';
import '../model/history_model.dart';

class HttpService {
  static const String _serverUrl = 'http://103.62.153.74:53000/dtr_history_api';
  static String get serverUrl => _serverUrl;

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
}
