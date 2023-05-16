import 'ccloud_group.dart';

class CloudUser{
  final String user_id;
  final String username;
  final List<Future<CloudGroup?>> joinedGroups;

  const CloudUser({
    required this.user_id,
    required this.username,
    required this.joinedGroups,
  });
}

