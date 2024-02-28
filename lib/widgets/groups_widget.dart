import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/group_provider.dart';
import '../view/edit_group_view.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  @override
  void initState() {
    super.initState();
    final group = Provider.of<GroupProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await group.getGroup();
    });
  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupProvider>(context);
    return AlertDialog(
      content: SizedBox(
        height: 500.0,
        width: 400.0,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(height: 0.0),
                itemCount: group.groupList.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox();
                  }
                  return ListTile(
                    title: Text(group.groupList[index].groupName),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditGroupView(groupModel: group.groupList[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
