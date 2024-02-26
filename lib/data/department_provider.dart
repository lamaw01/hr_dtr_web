import 'package:flutter/material.dart';

import '../model/department_model.dart';
import '../services/http_service.dart';

class DepartmentProvider with ChangeNotifier {
  final _departmentList = <DepartmentModel>[];
  List<DepartmentModel> get departmentList => _departmentList;

  var dropdownValue =
      DepartmentModel(departmentId: '000', departmentName: 'All');

  Future<void> getDepartment() async {
    _departmentList.add(dropdownValue);
    try {
      final result = await HttpService.getDepartment();
      _departmentList.addAll(result);
      notifyListeners();
    } catch (e) {
      debugPrint('$e getDepartment');
    }
  }
}
