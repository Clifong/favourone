abstract class DataTableEvent{
  const DataTableEvent();
}

class DataTableUpdateTableEvent extends DataTableEvent{
  final String groupName;
  final String ownerName;
  final String userId;
  final String ownerId;

  const DataTableUpdateTableEvent(this.groupName, this.ownerName, this.userId, this.ownerId);
}

class DataTableUpdateNotPresentTableEvent extends DataTableEvent{
  final String groupName;
  final String ownerName;
  final String userId;
  final String ownerId;

  const DataTableUpdateNotPresentTableEvent(this.groupName, this.ownerName, this.userId, this.ownerId);
}

class DataTableUpdatePresence extends DataTableEvent{
  final bool? bookIn;
  final String groupName;
  final String ownerId;
  final String ownerName;
  final String userId;

  const DataTableUpdatePresence(this.bookIn, this.groupName, this.ownerId, this.ownerName, this.userId);
}

class DataTableAddAdminEvent extends DataTableEvent{
  final String groupName;
  final String ownerId;
  final String toAddId;
  final bool add;

  const DataTableAddAdminEvent({required this.groupName, required this.ownerId, required this.toAddId, required this.add});
}