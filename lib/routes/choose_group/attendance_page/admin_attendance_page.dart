import 'package:favourone/cloud/firebase_cloud_storage.dart';
import 'package:favourone/routes/choose_group/attendance_page/admin_data_table_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import '../../../popup/dialog/error_dialog.dart';
import '../../../popup/dialog/generic_dialog.dart';
import 'admin_bookout_table_section.dart';

class AdminAttendancePage extends StatefulWidget {
  final Map arguement;
  const AdminAttendancePage({Key? key, required this.arguement})
      : super(key: key);

  @override
  State<AdminAttendancePage> createState() => _AdminAttendancePageState();
}

class _AdminAttendancePageState extends State<AdminAttendancePage> {
  late final TextEditingController _groupNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _doubleConfirmPasswordController;

  @override
  void initState() {
    _groupNameController = TextEditingController(
      text: widget.arguement['groupName']
    );
    _passwordController = TextEditingController(
      text: widget.arguement['password']
    );
    _doubleConfirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _passwordController.dispose();
    _doubleConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Attendance Page"),
            bottom: TabBar(tabs: [
              Tab(
                child: Column(
                  children: const [Icon(Icons.info), Text("Attendance")],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(Icons.exit_to_app),
                    Text("Booked out")
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(Icons.change_circle),
                    Text("Group info")
                  ],
                ),
              ),
            ]),
          ),
          body: TabBarView(
            children: [

              AdminDataTableSection(
                arguement: widget.arguement,
              ),

              AdminBookOutTable(
                arguement: widget.arguement,
              ),

              Column(children: [
                Flexible(
                  child: TextFormField(
                    controller: _groupNameController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      label: Text("Enter a new group name"),
                      hintText: "Group name",
                      icon: Icon(Icons.group),
                    ),
                  ),
                ),

                Flexible(
                  child: TextFormField(
                    controller: _passwordController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      label: Text("Enter a new password"),
                      hintText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                ),

                Flexible(
                  child: TextFormField(
                    controller: _doubleConfirmPasswordController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      label: Text("Re-enter a new password"),
                      hintText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                ),

                Flexible(
                  child: TextFormField(
                    initialValue: widget.arguement["groupId"],
                    readOnly: true,
                    decoration: const InputDecoration(
                      label: Text("Group Id"),
                      icon: Icon(Icons.group),
                    ),
                  ),
                ),

                Flexible(
                  child: TextButton(
                      child: const Text("Enter"),
                      onPressed: () async {
                        final arguement = widget.arguement;
                        if (_groupNameController.text.isEmpty) {
                          if (_doubleConfirmPasswordController.text !=
                              _passwordController.text) {
                            showErrorDialog(context, "Password not the same!");
                          } else if (estimatePasswordStrength(
                                  _passwordController.text) <
                              0.4) {
                            showGenericDialog(
                                context: context,
                                title: "Weak password",
                                content: "Password is too weak! Try again",
                                optionBuilder: () => {'ok': null});
                          } else {
                            showGenericDialog(
                                context: context,
                                title: "Change success",
                                content: "Successfully changed the data",
                                optionBuilder: () => {"Alright": null});
                            FirebaseCloudStorage().UpdatePassword(
                                groupName: arguement['groupName'],
                                ownerId: arguement["ownerId"],
                                newPassword: _passwordController.text);
                            _passwordController.clear();
                            _doubleConfirmPasswordController.clear();
                          }
                        } else if (_passwordController.text.isEmpty) {
                          showGenericDialog(
                              context: context,
                              title: "Change success",
                              content: "Successfully changed the data",
                              optionBuilder: () => {"Alright": null});
                          FirebaseCloudStorage().UpdateGroupName(
                            groupName: arguement['groupName'],
                            ownerId: arguement["ownerId"],
                            newName: _groupNameController.text,
                          );
                          _groupNameController.clear();
                        } else {
                          return;
                        }
                      }),
                )
              ]),
            ],
          ),
        ));
  }
}
