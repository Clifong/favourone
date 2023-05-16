import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/bloc/datatablebloc/data_table_state.dart';
import 'package:favourone/bloc/datatablebloc/data_table_bloc.dart';
import 'package:favourone/bloc/datatablebloc/data_table_event.dart';
import 'package:favourone/custom_item/admin_user_card.dart';
import 'package:favourone/custom_item/normal_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NormalDataTableSection extends StatefulWidget {
  final Map arguement;
  const NormalDataTableSection({Key? key, required this.arguement})
      : super(key: key);

  @override
  State<NormalDataTableSection> createState() => _NormalDataTableSectionState();
}

class _NormalDataTableSectionState extends State<NormalDataTableSection> {
  String get userId => FirebaseAuthProvider().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    final arguements = widget.arguement;
    return BlocBuilder<DataTableBloc, DataTableState>(
        builder: (context, state) {
          context.read<DataTableBloc>().add(DataTableUpdateTableEvent(
              arguements['groupName'], arguements['ownerName'], userId, arguements['ownerId']));
          if (state is DataTableUpdateState) {
            if (state.amIPresent == true) {
              return ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: state.usersPresentList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final username = snapshot.data as List<dynamic>;
                            if (arguements['isAdmin'] == true){
                              return AdminUserCard(
                                  userId: username[index],
                                  isPresentOrNot: true,
                                  ownerId: arguements['ownerId'],
                                  groupName: arguements['groupName'],
                                  ownerName: arguements['ownerName'],
                                  adminList: arguements['adminList'],
                              );
                            }
                            return NormalUserCard(
                              userId: username[index],
                              isPresentOrNot: true,
                            );
                          } else {
                            return const Text("");
                          }
                        });
                  });
            } else {
              return TextButton(
                  onPressed: () async {
                    context.read<DataTableBloc>().add(DataTableUpdatePresence(
                        true,
                        arguements['groupName'],
                        arguements['ownerId'],
                        arguements['ownerName'],
                        userId));
                  },
                  child: const Text("Join this group"));
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
