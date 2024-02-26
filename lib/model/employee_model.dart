// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

List<EmployeeModel> employeeModelFromJson(String str) =>
    List<EmployeeModel>.from(
        json.decode(str).map((x) => EmployeeModel.fromJson(x)));

String employeeModelToJson(List<EmployeeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeModel {
  int id;
  String employeeId;
  String firstName;
  String lastName;
  String middleName;
  String weekSchedId;
  int active;
  bool isSelected;

  EmployeeModel({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.weekSchedId,
    required this.active,
    this.isSelected = false,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        employeeId: json["employee_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        weekSchedId: json["week_sched_id"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "week_sched_id": weekSchedId,
        "active": active,
      };
}
