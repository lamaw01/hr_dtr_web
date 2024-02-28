import 'package:flutter/material.dart';

import '../model/employee_model.dart';
import '../services/http_service.dart';

class EmployeeProvider with ChangeNotifier {
  var _employeeList = <EmployeeModel>[];
  List<EmployeeModel> get employeeList => _employeeList;

  var _isSearching = false;
  bool get isSearching => _isSearching;

  var _searchEmployeeList = <EmployeeModel>[];
  List<EmployeeModel> get searchEmployeeList => _searchEmployeeList;

  void changeStateSearching(bool state) {
    _isSearching = state;
    notifyListeners();
  }

  String fullName(EmployeeModel m) {
    return '${m.lastName}, ${m.firstName} ${m.middleName}';
  }

  Future<void> getEmployee(
      {required String departmentId,
      List<EmployeeModel>? selectedEmployee,
      bool refresh = false}) async {
    try {
      final result = await HttpService.getEmployee(departmentId);
      _employeeList = result;
      if (selectedEmployee != null) {
        for (int i = 0; i < _employeeList.length; i++) {
          for (int j = 0; j < selectedEmployee.length; j++) {
            if (_employeeList[i].employeeId == selectedEmployee[j].employeeId) {
              _employeeList.removeAt(i);
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e getEmployee');
    }
  }

  Future<void> searchEmployee(
      {required String employeeId,
      required String departmentId,
      List<EmployeeModel>? selectedEmployee}) async {
    try {
      var result = await HttpService.searchEmployee(
          employeeId: employeeId, departmentId: departmentId);
      _searchEmployeeList = result;
      if (selectedEmployee != null) {
        for (int i = 0; i < _searchEmployeeList.length; i++) {
          for (int j = 0; j < selectedEmployee.length; j++) {
            if (_searchEmployeeList[i].employeeId ==
                selectedEmployee[j].employeeId) {
              _searchEmployeeList.removeAt(i);
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e searchEmployee');
    }
  }
}
