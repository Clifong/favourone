import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/importedauth/firebase_auth_provider.dart';
import '../../../bloc/datatablebloc/data_table_bloc.dart';
import '../../../bloc/datatablebloc/data_table_event.dart';
import '../../../bloc/datatablebloc/data_table_state.dart';
import '../../../custom_item/admin_user_card.dart';

class AdminBookOutTable extends StatefulWidget {
  final Map arguement;
  const AdminBookOutTable({Key? key, required this.arguement}) : super(key: key);

  @override
  State<AdminBookOutTable> createState() => _AdminBookOutTableState();
}

class _AdminBookOutTableState extends State<AdminBookOutTable> {
  String get userId => FirebaseAuthProvider().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    final arguements = widget.arguement;
    return BlocBuilder<DataTableBloc, DataTableState>(
        builder: (context, state) {
      context.read<DataTableBloc>().add(DataTableUpdateNotPresentTableEvent(
          arguements['groupName'],
          arguements['ownerName'],
          userId,
          arguements['ownerId']));
      if (state is DataTableUpdateNotPresentTableState) {
        if (state.amIPresent == true) {
          return ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                return StreamBuilder(
                    stream: state.usersNotPresentList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final username = snapshot.data as List<dynamic>;
                        if (username.isNotEmpty){
                          return AdminUserCard(
                            userId: username[index],
                            isPresentOrNot: false,
                            ownerId: arguements['ownerId'],
                            groupName: arguements['groupName'],
                            ownerName: arguements['ownerName'],
                            adminList: arguements['adminList'],
                          );
                        }
                        return const Center(child: Text("No users booked out"));
                      } else {
                        return const Text("");
                      }
                    });
              });
        }
        else {
          return const Center(child: Text("No users booked out"));
        }
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
