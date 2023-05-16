import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/cloud/field_name.dart';
import 'package:favourone/cloud/getters_methods/cloud_group.dart';
import 'package:flutter/material.dart';
import '../routes/route_string/routes.dart';

class NormalGroupCard extends StatelessWidget {
  final String groupName;
  final String ownerId;
  final String? ownerName;
  final String password;

  const NormalGroupCard(
      {Key? key,
      required this.groupName,
      required this.ownerName,
      required this.ownerId,
      required this.password})
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

          final userPresent =
              groupDoc.get(usersPresentFieldName) as List<dynamic>;

          final userNotPresent =
              groupDoc.get(usersPresentFieldName) as List<dynamic>;

          final adminList = groupDoc.get(adminIdFieldName) as List<dynamic>;

          if (!userPresent.contains(accessorUserId) ||
              !userNotPresent.contains(accessorUserId)) {
            final acess = await Navigator.of(context).pushNamed(passwordPopup,
                arguments: <String, String>{'password': password});
            if (acess == true) {
              if (adminList.contains(accessorUserId)){
                Navigator.of(context)
                    .pushNamed(normalAttendance, arguments: <String, dynamic?>{
                  'groupName': groupName,
                  'ownerId': ownerId,
                  'userId': accessorUserId,
                  'ownerName': ownerName,
                  'isAdmin': true,
                  'adminList': adminList,
                });
              }
              Navigator.of(context)
                  .pushNamed(normalAttendance, arguments: <String, dynamic?>{
                'groupName': groupName,
                'ownerId': ownerId,
                'userId': accessorUserId,
                'ownerName': ownerName,
                'isAdmin': false,
                'adminList': adminList,
              });
            }
          } else {
            if (adminList.contains(accessorUserId)){
              Navigator.of(context)
                  .pushNamed(normalAttendance, arguments: <String, dynamic?>{
                'groupName': groupName,
                'ownerId': ownerId,
                'userId': accessorUserId,
                'ownerName': ownerName,
                'isAdmin': true,
                'adminList': adminList,
              });
            }
            else {
              Navigator.of(context)
                  .pushNamed(normalAttendance, arguments: <String, dynamic?>{
                'groupName': groupName,
                'ownerId': ownerId,
                'userId': accessorUserId,
                'ownerName': ownerName,
                'isAdmin': false,
                'adminList': adminList,
              });
            }
          }
        },
        child: Column(
          children: [
            ListTile(
                title: Text("Group name: $groupName"),
                subtitle: Column(
                  children: [
                    Text("Created by: $ownerName"),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
