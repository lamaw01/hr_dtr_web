// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/department_provider.dart';
import '../data/employeee_provider.dart';
import '../data/group_provider.dart';
import '../model/department_model.dart';
import '../model/group_model.dart';

class EditGroupView extends StatefulWidget {
  const EditGroupView({super.key, required this.groupModel});
  final GroupModel groupModel;

  @override
  State<EditGroupView> createState() => _EditGroupViewState();
}

class _EditGroupViewState extends State<EditGroupView> {
  final groupNameController = TextEditingController();
  final searchController = TextEditingController();
  String initialGroupName = '';

  @override
  void initState() {
    super.initState();
    final employee = Provider.of<EmployeeProvider>(context, listen: false);
    final group = Provider.of<GroupProvider>(context, listen: false);
    final department = Provider.of<DepartmentProvider>(context, listen: false);
    group.clearEmployeeList();
    department.dropdownValue = department.departmentList[0];
    groupNameController.text = widget.groupModel.groupName;
    initialGroupName = widget.groupModel.groupName;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await employee.getEmployee(
          departmentId: department.dropdownValue.departmentId,
          selectedEmployee: group.employeeList);
      await group.getEmployeeGroup('${widget.groupModel.id}');
    });
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void confirmDeleteGroup(GroupModel groupModel) {
    final group = Provider.of<GroupProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Text('Delete ${groupModel.groupName} group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await group.deleteGroup(widget.groupModel);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'Edit Group';
    final employee = Provider.of<EmployeeProvider>(context);
    final group = Provider.of<GroupProvider>(context);
    final department = Provider.of<DepartmentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton(
            onPressed: () async {
              confirmDeleteGroup(widget.groupModel);
            },
            splashRadius: 20.0,
            tooltip: 'Delete Group',
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 800.0,
                  width: 500.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: searchController,
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          label: Text('Search..'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                        ),
                        onChanged: (String value) async {
                          if (searchController.text.isEmpty) {
                            employee.changeStateSearching(false);
                          } else {
                            employee.changeStateSearching(true);
                            await employee.searchEmployee(
                                employeeId: value.trim(),
                                departmentId:
                                    department.dropdownValue.departmentId,
                                selectedEmployee: group.employeeList);
                          }
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Department: ',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            height: 40.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<DepartmentModel>(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                borderRadius: BorderRadius.circular(5),
                                value: department.dropdownValue,
                                onChanged: (DepartmentModel? value) async {
                                  if (value != null) {
                                    setState(() {
                                      department.dropdownValue = value;
                                    });
                                    await employee.getEmployee(
                                        departmentId: department
                                            .dropdownValue.departmentId,
                                        selectedEmployee: group.employeeList);
                                  }
                                },
                                items: department.departmentList
                                    .map<DropdownMenuItem<DepartmentModel>>(
                                        (DepartmentModel value) {
                                  return DropdownMenuItem<DepartmentModel>(
                                    value: value,
                                    child: Text(value.departmentName),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: SizedBox(
                          // height: 400.0,
                          width: 500.0,
                          child: employee.isSearching
                              ? ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(height: 0.0),
                                  itemCount: employee.searchEmployeeList.length,
                                  itemBuilder: ((context, index) {
                                    return CheckboxListTile(
                                      title: Text(employee.fullName(
                                          employee.searchEmployeeList[index])),
                                      value: employee
                                          .searchEmployeeList[index].isSelected,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          setState(() {
                                            employee.searchEmployeeList[index]
                                                .isSelected = value;
                                          });
                                        }
                                      },
                                      dense: true,
                                    );
                                  }),
                                )
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Divider(height: 0.0),
                                  itemCount: employee.employeeList.length,
                                  itemBuilder: ((context, index) {
                                    return CheckboxListTile(
                                      title: Text(employee.fullName(
                                          employee.employeeList[index])),
                                      value: employee
                                          .employeeList[index].isSelected,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          setState(() {
                                            employee.employeeList[index]
                                                .isSelected = value;
                                          });
                                        }
                                      },
                                      dense: true,
                                    );
                                  }),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        color: Colors.green[300],
                        width: double.infinity,
                        height: 40.0,
                        child: TextButton(
                          onPressed: () async {
                            final listEmp = employee.employeeList
                                .where((e) => e.isSelected == true);

                            final listSearchEmp = employee.searchEmployeeList
                                .where((e) => e.isSelected == true);

                            group.addToList(listEmp);
                            group.addToList(listSearchEmp);

                            await employee.getEmployee(
                                departmentId:
                                    department.dropdownValue.departmentId,
                                selectedEmployee: group.employeeList);
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 800.0,
                  width: 400.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: groupNameController,
                        style: const TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          label: Text('Group name..'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: SizedBox(
                          width: 500.0,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(height: 0.0),
                            itemCount: group.employeeList.length,
                            itemBuilder: ((context, index) {
                              // return SizedBox(
                              //   height: 40.0,
                              //   child: Center(
                              //     child: Text(
                              //       textAlign: TextAlign.start,
                              //       employee
                              //           .fullName(group.employeeList[index]),
                              //       style: const TextStyle(fontSize: 13.0),
                              //     ),
                              //   ),
                              // );
                              return CheckboxListTile(
                                title: Text(employee
                                    .fullName(group.employeeList[index])),
                                value: group.employeeList[index].isSelected,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      group.employeeList[index].isSelected =
                                          value;
                                    });
                                  }
                                },
                                dense: true,
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        color: Colors.green[300],
                        width: double.infinity,
                        height: 40.0,
                        child: TextButton(
                          onPressed: () async {
                            if (groupNameController.text.isEmpty) {
                              showErrorSnackBar('Empty Group Name');
                              return;
                            }

                            group.addNewEmp();

                            final newGroup = GroupModel(
                                id: widget.groupModel.id,
                                groupName: groupNameController.text.trim());

                            await group.editGroup(
                              group: newGroup,
                              updateGroupName:
                                  initialGroupName != newGroup.groupName
                                      ? 1
                                      : 0,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
