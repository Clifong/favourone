import 'dart:async';
import 'package:favourone/bloc/datatablebloc/data_table_state.dart';
import 'package:favourone/bloc/datatablebloc/data_table_event.dart';
import 'package:favourone/cloud/field_name.dart';
import 'package:favourone/cloud/getters_methods/cloud_group.dart';
import 'package:favourone/cloud/getters_methods/cloud_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cloud/firebase_cloud_storage.dart';

class DataTableBloc extends Bloc<DataTableEvent, DataTableState> {
  DataTableBloc() : super(const DataTableDefaultState()) {

    on<DataTableUpdateTableEvent>((event, emit) async {
      final groupDocument = await getCloudGroup(
        groupName: event.groupName,
        ownerId: event.ownerId,
      );
      final usersPresentUserIdList = groupDocument.usersPresentList;
      final amIPresent = (usersPresentUserIdList.contains(event.userId));
      final groupDoc = await getCloudGroup(
        groupName: event.groupName,
        ownerId: event.ownerId,
      );
      final stream = Stream.fromIterable(groupDoc.usersPresentList).toList().asStream().asBroadcastStream();
      final length = usersPresentUserIdList.length;
      emit(DataTableUpdateState(stream, length, amIPresent));
    });

    on<DataTableUpdateNotPresentTableEvent>((event, emit) async {
      final groupDocument = await getCloudGroup(
        groupName: event.groupName,
        ownerId: event.ownerId,
      );
      final usersNotPresentUserIdList = groupDocument.usersNotPresentList;
      final amIPresent = (usersNotPresentUserIdList.contains(event.userId));
      final groupDoc = await getCloudGroup(
        groupName: event.groupName,
        ownerId: event.ownerId,
      );
      final stream = Stream.fromIterable(groupDoc.usersNotPresentList).toList().asStream().asBroadcastStream();
      final length = usersNotPresentUserIdList.length;
      emit(DataTableUpdateNotPresentTableState(stream, length, amIPresent));
    });

    on<DataTableUpdatePresence>((event, emit) async {
      final cloudUserDoc = await getCloudUserDocument(userId: event.userId);
      final cloudDoc = await getCloudGroupDocument(
          groupName: event.groupName, ownerId: event.ownerId);
      final joinedGroup = cloudUserDoc.get(joinedGroupsFieldName) as List<dynamic>;
      if (!joinedGroup.contains(cloudDoc.id)) {
        FirebaseCloudStorage().AddNewJoinedGroup(
          userId: event.userId,
          groupName: event.groupName,
          ownerId: event.ownerId,
        );
      }
      if (event.bookIn != null){
        FirebaseCloudStorage().UpdateOrAddIsPresentOrNot(
            user_id: event.userId,
            bookIn: event.bookIn,
            ownerName: event.ownerName,
            groupName: event.groupName
        );
      }
    }
    );

    on<DataTableAddAdminEvent>((event, emit) async{
      await FirebaseCloudStorage().UpdateAdminList(
          groupName: event.groupName,
          ownerId: event.ownerId,
          toAddId: event.toAddId,
          add: event.add,
      );
    });
  }
}

