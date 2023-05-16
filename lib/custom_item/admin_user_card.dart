import 'package:favourone/bloc/datatablebloc/data_table_bloc.dart';
import 'package:favourone/bloc/datatablebloc/data_table_event.dart';
import 'package:favourone/cloud/getters_methods/cloud_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/importedauth/firebase_auth_provider.dart';
import '../cloud/cloud_user.dart';
import '../popup/dialog/generic_dialog.dart';

class AdminUserCard extends StatelessWidget {
  final String userId;
  final bool isPresentOrNot;
  final String ownerId;
  final String groupName;
  final String ownerName;
  final List<dynamic> adminList;

  const AdminUserCard(
      {required this.userId,
      required this.isPresentOrNot,
      required this.ownerId,
      required this.groupName,
      required this.ownerName,
      required this.adminList});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCloudUser(userId: userId),
        builder: (context, snapshot) {
          final accessorUserId = FirebaseAuthProvider().currentUser!.id;
          if (snapshot.hasData) {
            final cloudUser = snapshot.data as CloudUser;
            return Card(
              color: isPresentOrNot == true ? Colors.green : Colors.red,
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 30.0,
                ),
                title: Text(cloudUser.username,
                    style: const TextStyle(fontSize: 20.0)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isPresentOrNot == true ? "Present" : "Absent"),
                    Text(adminList.contains(cloudUser.user_id) ? "ADMIN" : ""),
                  ],
                ),
                trailing: DropdownButton(
                  icon: const Icon(Icons.more_vert),
                  onChanged: (String? value) async {
                    switch (value) {
                      case 'Admin information':
                        if (!adminList.contains(cloudUser.user_id)) {
                          final result = await showGenericDialog(
                              context: context,
                              title: "What do you want to do?",
                              content:
                                  "Do you want to make ${cloudUser.username} an admin?",
                              optionBuilder: () => {
                                    'No': false,
                                    'Yes': true,
                                  });
                          if (result == true) {
                            context.read<DataTableBloc>().add(
                                DataTableAddAdminEvent(
                                    groupName: groupName,
                                    ownerId: ownerId,
                                    toAddId: cloudUser.user_id,
                                    add: true));
                          }
                        } else {
                          final result = await showGenericDialog(
                              context: context,
                              title: "What do you want to do?",
                              content:
                                  "Do you want to remove ${cloudUser.username}'s admin privilege?",
                              optionBuilder: () => {
                                    'No': false,
                                    'Yes': true,
                                  });
                          if (result == true) {
                            context.read<DataTableBloc>().add(
                                DataTableAddAdminEvent(
                                    groupName: groupName,
                                    ownerId: ownerId,
                                    toAddId: cloudUser.user_id,
                                    add: false));
                          }
                        }
                        break;
                      case "Book out":
                        if (accessorUserId == ownerId) {
                          final result = await showGenericDialog(
                              context: context,
                              title: "What do you want to do?",
                              content:
                                  "Do you want to ${isPresentOrNot == false ? "book in" : "book out"} ${cloudUser.username}?",
                              optionBuilder: () => {
                                    'No': null,
                                    'Yes': !isPresentOrNot,
                                  });
                          if (result != null) {
                            context.read<DataTableBloc>().add(
                                DataTableUpdatePresence(result, groupName,
                                    ownerId, ownerName, userId));
                          }
                        }
                        break;
                    }
                  },
                  items: [
                    DropdownMenuItem(
                        value: 'Admin information',
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: const [
                            Text("Changing admin info"),
                          ]),
                        )),
                    DropdownMenuItem(
                        value: "Book out",
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              if (isPresentOrNot == true) ...[
                                const Text("Book out")
                              ] else ...[
                                const Text("Book in")
                              ]
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            );
          } else {
            return const Text("");
          }
        });
  }
}
