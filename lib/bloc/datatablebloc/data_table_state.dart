import 'dart:async';

abstract class DataTableState{
  const DataTableState();
}

class DataTableDefaultState extends DataTableState{
  const DataTableDefaultState();
}

class DataTableUpdateState extends DataTableState{
  Stream<List<dynamic>> usersPresentList;
  int length;
  bool? amIPresent;

  DataTableUpdateState(this.usersPresentList, this.length, this.amIPresent);
}

class DataTableUpdateNotPresentTableState extends DataTableState{
  Stream<List<dynamic>> usersNotPresentList;
  int length;
  bool? amIPresent;

  DataTableUpdateNotPresentTableState(this.usersNotPresentList, this.length, this.amIPresent);
}