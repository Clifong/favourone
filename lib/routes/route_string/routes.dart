import 'package:favourone/bloc/attendancebloc/attendance_bloc.dart';
import 'package:favourone/bloc/datatablebloc/data_table_bloc.dart';
import 'package:favourone/bloc/grouppagebloc/group_page_bloc.dart';
import 'package:favourone/routes/choose_group/attendance_page/normal_attendance_page.dart';
import 'package:favourone/routes/choose_group/choose_group.dart';
import 'package:favourone/routes/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../popup/dialog/password_input_dialog.dart';
import '../choose_group/attendance_page/admin_attendance_page.dart';
import '../home_page.dart';

const profile = "lib/routes/profile_page.dart";
const chooseGroup = "lib/routes/choose_group.dart";
const adminAttendance =
    "lib/routes/choose_group/attendance_page/admin_attendance_page.dart";
const normalAttendance =
    "lib/routes/choose_group/attendance_page/normal_attendance_page.dart";
const passwordPopup = "lib/dialog/password_input_dialog.dart";

class AppRoute {
  Route generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case (profile):
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
        );

      case (adminAttendance):
        final arguement = routeSettings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (_) => DataTableBloc(),
                child: AdminAttendancePage(arguement: arguement))
        );

      case (normalAttendance):
        final arguement = routeSettings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (_) => DataTableBloc(),
                child: NormalAttendancePage(arguement: arguement))
        );

      case (chooseGroup):
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => AttendanceBloc(),
                      child: const ChooseGroup(),
                    ),
                    BlocProvider(
                      create: (_) => GroupPageBloc(),
                      child: const ChooseGroup(),
                    ),
                  ],
                  child: const ChooseGroup(),
                ));

      case (passwordPopup):
        final arguement = routeSettings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) {
              return PasswordPopupDialog(arguements: arguement);
            }
        );

      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
