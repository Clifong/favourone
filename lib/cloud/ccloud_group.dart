class CloudGroup {
  final String groupId;
  final String name;
  final String? ownerName;
  final String password;
  final String ownerId;
  final List<dynamic> adminUserList;
  final List<dynamic> usersPresentList;
  final List<dynamic> usersNotPresentList;

  const CloudGroup({
    required this.groupId,
    required this.name,
    required this.ownerName,
    required this.password,
    required this.ownerId,
    required this.adminUserList,
    required this.usersPresentList,
    required this.usersNotPresentList,
  });
}