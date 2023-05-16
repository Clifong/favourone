import 'package:favourone/bloc/grouppagebloc/group_page_state.dart';
import 'package:favourone/bloc/grouppagebloc/group_page_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPageBloc extends Bloc<GroupPageEvent, GroupPageState>{
  GroupPageBloc() : super(const GroupPageDefaultState()){

    on<GroupPageChangeIndexEvent>((event, emit){
      switch (event.index){
        case 0:
          emit(const GroupPageSearchState());
          break;
        case 1:
          emit(const GroupPageMyGroupState());
          break;
        case 2:
          emit(const GroupPageCreateGroupState());
          break;
      }
    });

  }

}