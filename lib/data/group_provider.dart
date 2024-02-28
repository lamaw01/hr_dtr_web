import 'package:flutter/material.dart';

import '../model/employee_model.dart';
import '../model/group_model.dart';
import '../services/http_service.dart';

class GroupProvider with ChangeNotifier {
  var _employeeList = <EmployeeModel>[];
  List<EmployeeModel> get employeeList => _employeeList;

  final _initialEmployeeList = <EmployeeModel>[];

  var _groupList = <GroupModel>[];
  List<GroupModel> get groupList => _groupList;

  var dropdownValue = GroupModel(id: 0, groupName: 'None');

  final _employeeIdNew = <String>[];

  final _employeeIdRemove = <String>[];

  void removeEmployee(int index) {
    _employeeList.removeAt(index);
    notifyListeners();
  }

  void addNewEmp() {
    for (int i = 0; i < _employeeList.length; i++) {
      if (_initialEmployeeList.contains(_employeeList[i])) {
        if (!_employeeList[i].isSelected) {
          _employeeIdRemove.add(_employeeList[i].employeeId);
        }
      } else {
        if (_employeeList[i].isSelected) {
          _employeeIdNew.add(_employeeList[i].employeeId);
        }
      }
    }

    // log('_employeeIdNew ${_employeeIdNew.length} _employeeIdRemove ${_employeeIdRemove.length}');
  }

  void addToList(Iterable<EmployeeModel> listOfSelected) {
    // var tempList = <EmployeeModel>[];
    // tempList.addAll(listOfSelected);
    _employeeList.addAll(listOfSelected);
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
      // _groupList.add(dropdownValue);
      _groupList.insert(0, dropdownValue);
      notifyListeners();
    } catch (e) {
      debugPrint('$e getGroup');
    }
  }

  Future<void> getEmployeeGroup(String groupId) async {
    try {
      final result = await HttpService.getEmployeeGroup(groupId);
      _employeeList = result;
      for (var emp1 in _employeeList) {
        emp1.isSelected = true;
      }
      _initialEmployeeList.clear();
      _initialEmployeeList.addAll(result);
      notifyListeners();
    } catch (e) {
      debugPrint('$e getEmployeeGroup');
    }
  }

  Future<void> editGroup({
    required GroupModel group,
    required int updateGroupName,
  }) async {
    try {
      await HttpService.editGroup(
        group: group,
        employeeIdNew: _employeeIdNew,
        employeeIdRemove: _employeeIdRemove,
        updateGroupName: updateGroupName,
      );
    } catch (e) {
      debugPrint('$e editGroup');
    } finally {
      _employeeIdNew.clear();
      _employeeIdRemove.clear();
      await getGroup();
    }
  }

  Future<void> deleteGroup(GroupModel group) async {
    try {
      await HttpService.deleteGroup(group: group);
    } catch (e) {
      debugPrint('$e deleteGroup');
    } finally {
      await getGroup();
    }
  }
}
