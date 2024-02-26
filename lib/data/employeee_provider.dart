import 'package:flutter/material.dart';

import '../model/employee_model.dart';
import '../services/http_service.dart';

class EmployeeProvider with ChangeNotifier {
  var _employeeList = <EmployeeModel>[];
  List<EmployeeModel> get employeeList => _employeeList;

  var _isSearching = false;
  bool get isSearching => _isSearching;

  final _searchEmployeeList = <EmployeeModel>[];
  List<EmployeeModel> get searchEmployeeList => _searchEmployeeList;

  void changeStateSearching(bool state) {
    _isSearching = state;
    notifyListeners();
  }

  String fullName(EmployeeModel m) {
    return '${m.lastName}, ${m.firstName} ${m.middleName}';
  }

  Future<void> getEmployee(String departmentId) async {
    try {
      final result = await HttpService.getEmployee(departmentId);
      _employeeList = result;
      notifyListeners();
    } catch (e) {
      debugPrint('$e getEmployee');
    }
  }

  Future<void> searchEmployee(
      {required String employeeId, required String departmentId}) async {
    try {
      var result = await HttpService.searchEmployee(
          employeeId: employeeId, departmentId: departmentId);
      _searchEmployeeList.replaceRange(0, _searchEmployeeList.length, result);
      notifyListeners();
    } catch (e) {
      debugPrint('$e searchEmployee');
    }
  }
}
