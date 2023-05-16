import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../cloud/ccloud_group.dart';

abstract class AttendanceState{
  const AttendanceState();
}

class AttendanceStateDefault extends AttendanceState{
  AttendanceStateDefault();
}

class UpdateGroupListState extends AttendanceState{
  StreamController<Iterable<CloudGroup>> controller;

  UpdateGroupListState(this.controller);
}

class UpdateMyGroupListState extends AttendanceState{
  Stream<Iterable<CloudGroup>> streamAll;
  Stream<List<Future<CloudGroup?>>> streamJoined;
  int length;

  UpdateMyGroupListState(this.streamAll, this.streamJoined, this.length);
}

class UpdateAttendanceState extends AttendanceState{
  Future<QueryDocumentSnapshot<Map<String, dynamic>>> newCloudGroupDocument;

  UpdateAttendanceState(this.newCloudGroupDocument);
}