import 'package:favourone/bloc/datatablebloc/data_table_bloc.dart';
import 'package:favourone/routes/choose_group/attendance_page/normal_data_table_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/importedauth/firebase_auth_provider.dart';
import '../../../bloc/datatablebloc/data_table_state.dart';

class NormalAttendancePage extends StatefulWidget {
  final Map arguement;
  const NormalAttendancePage({Key? key, required this.arguement})
      : super(key: key);

  @override
  State<NormalAttendancePage> createState() => _NormalAttendancePageState();
}

class _NormalAttendancePageState extends State<NormalAttendancePage> {
  String get userId => FirebaseAuthProvider().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        BlocBuilder<DataTableBloc, DataTableState>(builder: (context, state) {
      return DefaultTabController(
          length: 1,
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Attendance Page"),
                bottom: TabBar(tabs: [
                  Tab(
                    child: Column(
                      children: const [
                        Icon(Icons.info),
                        Text("Attendance info")
                      ],
                    ),
                  ),
                ]),
              ),

              body: TabBarView(
                  children: [
                NormalDataTableSection(arguement: widget.arguement),
              ]
              )
          )
      );
    })
    );
  }
}
