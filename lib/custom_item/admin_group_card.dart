import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/cloud/field_name.dart';
import 'package:flutter/material.dart';
import '../cloud/firebase_cloud_storage.dart';
import '../cloud/getters_methods/cloud_group.dart';
import '../popup/dialog/generic_dialog.dart';
import '../routes/route_string/routes.dart';

class AdminGroupCard extends StatelessWidget {
  final String groupName;
  final String ownerId;
  final String? ownerName;
  final String password;
  final String groupId;

  const AdminGroupCard({Key? key,
    required this.groupId,
    required this.groupName,
    required this.ownerName,
    required this.ownerId,
    required this.password
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessorUserId = FirebaseAuthProvider().currentUser!.id;

    return Card(
      shape: const RoundedRectangleBorder(),
      child: InkWell(
        onTap: () async {

          final groupDoc = await getCloudGroupDocument(
              groupName: groupName, ownerId: ownerId);

          final adminList = groupDoc.get(adminIdFieldName) as List<dynamic>;

          if (accessorUserId == ownerId) {
            Navigator.of(context)
                .pushNamed(adminAttendance, arguments: <String, dynamic?>{
              'groupId': groupId,
              'groupName': groupName,
              'ownerId': ownerId,
              'userId': accessorUserId,
              'ownerName': ownerName,
              'adminList': adminList,
              'password': password
            });
          } else {
            Navigator.of(context)
                .pushNamed(normalAttendance, arguments: <String, dynamic?>{
              'groupId': groupId,
              'groupName': groupName,
              'ownerId': ownerId,
              'userId': accessorUserId,
              'ownerName': ownerName,
              'adminList': adminList,
            });
          }
        },
        child: Column(
          children: [
            ListTile(
                title: Text("Group name: $groupName"),
                subtitle: Row(
                  children: [
                    Text("Created by: $ownerName"),
                    IconButton(
                        onPressed: () async {
                          final result = await showGenericDialog(
                              context: context,
                              title: "Delete group?",
                              content: "Do you want to delete group?",
                              optionBuilder: () => {"No": null, "Yes": true});
                          (result ?? false) == true
                              ? FirebaseCloudStorage().DeleteGroupDocument(
                                  ownerId: ownerId, groupName: groupName)
                              : false;
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
