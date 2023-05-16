import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:favourone/custom_item/normal_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/attendancebloc/attendance_bloc.dart';
import '../../bloc/attendancebloc/attendance_event.dart';
import '../../bloc/attendancebloc/attendance_state.dart';
import '../../cloud/ccloud_group.dart';
import '../../cloud/getters_methods/cloud_group.dart';
import '../../popup/dialog/error_dialog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchGroupIdController;

  @override
  void initState() {
    _searchGroupIdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchGroupIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        child: AnimSearchBar(
            autoFocus: true,
            width: MediaQuery.of(context).size.width,
            textController: _searchGroupIdController,
            helpText: "Search a group",
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            suffixIcon: const Icon(Icons.clear, color: Colors.black),
            onSuffixTap: () {
              setState(() {
                _searchGroupIdController.clear();
              });
            }),
      ),

      TextButton(
          onPressed: () async {
            if (_searchGroupIdController.text.isNotEmpty) {
              final updatedCloudGroup = await getCloudGroupDocumentUsingId(
                groupId: _searchGroupIdController.text
              );
              context
                  .read<AttendanceBloc>()
                  .add(UpdateGroupAttendanceListEvent(updatedCloudGroup));
            } else {
              showErrorDialog(context, "Hey, no empty text allowed!");
            }
          },
          child: const Text("Enter")),

      const Divider(
        color: Colors.white,
        height: 30.0,
        thickness: 2.0,
      ),

      Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16)),
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
          if (state is UpdateGroupListState) {
            return StreamBuilder(
                stream: state.controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final _items = snapshot.data as List<CloudGroup>;
                    if (_items.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _items.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return NormalGroupCard(
                              groupName: _items[index].name,
                              ownerName: _items[index].ownerName,
                              ownerId: _items[index].ownerId,
                              password: _items[index].password,
                            );
                          });
                    } else {
                      return Column(
                        children: const [
                          Icon(Icons.not_interested),
                          Text(
                              "No groups found. Did you type something wrongly?")
                        ],
                      );
                    }
                  } else {
                    return const Text("Gathering data...");
                  }
                });
          }
          return Column(
            children: const [Icon(Icons.input), Text("Awaiting input...")],
          );
        }),
      ),
    ]);
  }
}
