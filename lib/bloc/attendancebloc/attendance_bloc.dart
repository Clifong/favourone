import 'dart:async';
import 'package:favourone/auth/importedauth/firebase_auth_provider.dart';
import 'package:favourone/bloc/attendancebloc/attendance_state.dart';
import 'package:favourone/bloc/attendancebloc/attendance_event.dart';
import 'package:favourone/cloud/getters_methods/cloud_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cloud/ccloud_group.dart';
import '../../cloud/getters_methods/cloud_group.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState>{
  AttendanceBloc() : super(AttendanceStateDefault()) {

    on<UpdateGroupAttendanceListEvent>((event, emit){
      StreamController<Iterable<CloudGroup>> controller = StreamController.broadcast();
      controller.addStream(event.updatedCloudGroup);
      emit(UpdateGroupListState(controller));
    });

    on<UpdateMyGroupListEvent>((event, emit) async{
      final userId = FirebaseAuthProvider().currentUser!.id;
      final cloudUser = await getCloudUser(userId: userId);
      final updatedCloudListStream = (await getAllCloudGroups(ownerName: cloudUser.username)).asBroadcastStream();
      final joinedGroups = cloudUser.joinedGroups;
      final joinedStream = Stream.fromIterable(joinedGroups).toList().asStream().asBroadcastStream();
      emit(UpdateMyGroupListState(updatedCloudListStream, joinedStream, joinedGroups.length));
    });

    on<AttendanceChangeEvent>((event, emit) {
      emit(UpdateAttendanceState(event.newCloudGroupDocument));
    });
  }
}