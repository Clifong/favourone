import 'dart:async';

import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/bloc/attendancebloc/attendance_bloc.dart';
import 'package:favourone/bloc/attendancebloc/attendance_event.dart';
import 'package:favourone/bloc/attendancebloc/attendance_state.dart';
import 'package:favourone/cloud/ccloud_group.dart';
import 'package:favourone/custom_item/admin_group_card.dart';
import 'package:favourone/custom_item/normal_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyGroup extends StatefulWidget {
  const MyGroup({Key? key}) : super(key: key);

  @override
  State<MyGroup> createState() => _MyGroupState();
}

class _MyGroupState extends State<MyGroup> {
  String get userId => FirebaseAuthProvider().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        context.read<AttendanceBloc>().add(UpdateMyGroupListEvent());
        if (state is UpdateMyGroupListState) {
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 1,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Column(
                          children: const [
                            Icon(Icons.person),
                            Text("Groups I created"),
                          ],
                        ),
                      ),
                      Tab(
                          child: Column(
                        children: const [
                          Icon(Icons.people),
                          Text("Groups I joined")
                        ],
                      )),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    StreamBuilder(
                      stream: state.streamAll,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final _items = snapshot.data as List<CloudGroup>;
                          if (_items.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  return AdminGroupCard(
                                    groupId: _items[index].groupId,
                                    groupName: _items[index].name,
                                    ownerName: _items[index].ownerName,
                                    ownerId: _items[index].ownerId,
                                    password: _items[index].password
                                  );
                                });
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.face),
                                  Text(
                                      "You have not created any groups yet! Start creating one!")
                                ],
                              ),
                            );
                          }
                        } else {
                          return const Text("Loading");
                        }
                      },
                    ),
                    StreamBuilder(
                      stream: state.streamJoined,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final _items =
                              snapshot.data as List<Future<CloudGroup?>>;
                          if (_items.length == 0) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.face),
                                  Text(
                                      "You have not joined any groups yet! Go join one now!")
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                              itemCount: state.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                    future: _items[index],
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final data =
                                            snapshot.data as CloudGroup;
                                        if (data.ownerId == userId) {
                                          return AdminGroupCard(
                                            groupId: data.groupId,
                                            groupName: data.name,
                                            ownerName: data.ownerName,
                                            ownerId: data.ownerId,
                                            password: data.password,
                                          );
                                        }
                                        return NormalGroupCard(
                                          groupName: data.name,
                                          ownerName: data.ownerName,
                                          ownerId: data.ownerId,
                                          password: data.password,
                                        );
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    });
                              });
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
