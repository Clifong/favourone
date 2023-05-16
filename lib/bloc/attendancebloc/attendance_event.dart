import 'package:cloud_firestore/cloud_firestore.dart';
import '../../cloud/ccloud_group.dart';

abstract class AttendanceEvent{
  const AttendanceEvent();
}

class UpdateGroupAttendanceListEvent extends AttendanceEvent{
  Stream<Iterable<CloudGroup>> updatedCloudGroup;

  UpdateGroupAttendanceListEvent(this.updatedCloudGroup);
}

class UpdateMyGroupListEvent extends AttendanceEvent{
  UpdateMyGroupListEvent();
}

class UpdateJoinedGroupListEvent extends AttendanceEvent{
  UpdateJoinedGroupListEvent();
}


class AttendanceChangeEvent extends AttendanceEvent{
  Future<QueryDocumentSnapshot<Map<String, dynamic>>> newCloudGroupDocument;

  AttendanceChangeEvent(this.newCloudGroupDocument);
}

