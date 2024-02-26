import 'package:flutter/material.dart';

import '../model/employee_model.dart';
import '../model/group_model.dart';
import '../services/http_service.dart';

class GroupProvider with ChangeNotifier {
  var _employeeList = <EmployeeModel>[];
  List<EmployeeModel> get employeeList => _employeeList;

  var _groupList = <GroupModel>[];
  List<GroupModel> get groupList => _groupList;

  void addToList(Iterable<EmployeeModel> listOfSelected) {
    var tempList = <EmployeeModel>[];
    tempList.addAll(listOfSelected);
    _employeeList = tempList;
    notifyListeners();
  }

  void clearEmployeeList() {
    _employeeList.clear();
  }

  Future<void> addGroup(String groupName) async {
    final listOfEmployee = <String>[];
    for (var emp in _employeeList) {
      listOfEmployee.add(emp.employeeId);
    }

    try {
      await HttpService.addGroup(
          employeeId: listOfEmployee, groupName: groupName);
    } catch (e) {
      debugPrint('$e addGroup');
    }
  }

  Future<void> getGroup() async {
    try {
      final result = await HttpService.getGroup();
      _groupList = result;
      notifyListeners();
    } catch (e) {
      debugPrint('$e getDepartment');
    }
  }
}
