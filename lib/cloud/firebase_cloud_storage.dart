import "package:cloud_firestore/cloud_firestore.dart";
import 'package:favourone/auth/user.dart';
import 'package:favourone/cloud/cloud_exception.dart';
import 'package:favourone/cloud/field_name.dart';
import 'package:favourone/cloud/getters_methods/cloud_group.dart';
import 'package:favourone/cloud/getters_methods/cloud_user.dart';

class FirebaseCloudStorage{

  final userCloudList = FirebaseFirestore.instance.collection("users");
  final groupCloudList = FirebaseFirestore.instance.collection("group");

  //Addition
  void AddNewUser({required AuthUser user}) async{
    try{
      final username = user.email!.substring(0, user.email!.indexOf('@'));
      await userCloudList.add({
        userIdFieldName: user.id,
        usernameFieldName: username,
        joinedGroupsFieldName: []
    });
        }
    catch(e) {
      throw CannotAddCloudUserException();
      }
    }

    void AddNewGroup({required String groupName, required String password, required String ownerName, required String ownerId}) async{
      try{
        await groupCloudList.add({
          groupIdFieldName: "",
          groupNameFieldName: groupName,
          passwordFieldName: password,
          ownerNameFieldName: ownerName,
          ownerIdFIeldName: ownerId,
          adminIdFieldName: [],
          usersPresentFieldName: [],
          usersNotPresentFieldName: [],
        });
        final groupDoc = await getCloudGroupDocument(groupName: groupName, ownerId: ownerId);
        groupCloudList.doc(groupDoc.id).update({
          groupIdFieldName: groupDoc.id
        }
        );
      } catch(e){
        throw CannotCreateGroupException();
      }
    }

    void AddNewJoinedGroup({required String userId, required String groupName, required String ownerId}) async{
      try{
        final groupDoc = await getCloudGroupDocument(groupName: groupName, ownerId: ownerId);
        final cloudUserDoc = await getCloudUserDocument(userId: userId);
        final cloudUserJoinedGroup = await cloudUserDoc.get(joinedGroupsFieldName) as List<dynamic>;
        cloudUserJoinedGroup.add(groupDoc.id);
        userCloudList.doc(cloudUserDoc.id).update({
          joinedGroupsFieldName: cloudUserJoinedGroup
        });
      } catch(e){
        throw e;
      }
    }

    //Delete group
  void DeleteGroupDocument({required String ownerId, required String groupName}) async{
    final groupDoc = await getCloudGroupDocument(groupName: groupName, ownerId: ownerId);
    userCloudList.where(joinedGroupsFieldName, arrayContains: groupDoc.id).get().then(
            (documentList) => documentList.docs.map(
                    (document) {
                      print('a');
                      final joinedGroup = document.get(joinedGroupsFieldName) as List<dynamic>;
                      joinedGroup.remove(groupDoc.id);
                      userCloudList.doc(document.id).update({
                        joinedGroupsFieldName: joinedGroup
                      });
                    }
            ).toList()
    );
    await groupCloudList.doc(groupDoc.id).delete();
  }

    //Update user credentials
  Future<void> UpdateUserUsername({required String userId, required String username, required String oldUsername}) async{
    try{
      await UpdateUsernameInCloudDocument(newUsername: username, oldUsername: oldUsername);
      final userDocumentId = await getCloudUserDocument(userId: userId).then(
              (userDocument) => userDocument.id
      );
      await (userCloudList.doc(userDocumentId).update({
        usernameFieldName: username,
        })
     );
    }
    catch(e){
      print(e);
      throw CannotUpdateCloudUserUsernameException();
      }
    }

    Future<void> UpdateUsernameInCloudDocument({required String newUsername, required String oldUsername}) async{
    await groupCloudList.where(ownerNameFieldName, isEqualTo: oldUsername).get().then(
            (listDocuments) => listDocuments.docs.map(
                    (document) =>
                      groupCloudList.doc(document.id).update({
                        ownerNameFieldName: newUsername,
                      })
              ).toList()
            );
  }

    Future<void> UpdateOrAddIsPresentOrNot({required String user_id, required bool? bookIn, required String ownerName, required String groupName}) async{
    try {
      await groupCloudList
          .where(ownerNameFieldName, isEqualTo: ownerName)
          .where(groupNameFieldName, isEqualTo: groupName).get().then(
              (documentList) => documentList.docs.map(
                      (document) async {
                        final doc = await groupCloudList.doc(document.id).get();
                        final newPresentList = doc.get(usersPresentFieldName) as List<dynamic>;
                        final newNotPresentList = doc.get(usersNotPresentFieldName) as List<dynamic>;
                        if (bookIn == true){
                          final user = await getCloudUser(userId: user_id);
                          newPresentList.add(user.user_id);
                          newNotPresentList.remove(user.user_id);
                        }
                        else {
                          final user = await getCloudUser(userId: user_id);
                          newPresentList.remove(user.user_id);
                          newNotPresentList.add(user.user_id);
                        }
                        groupCloudList.doc(document.id).update({
                          usersPresentFieldName: newPresentList,
                          usersNotPresentFieldName: newNotPresentList ,
                        });
                      }
              ).toList()
      );
    } catch(e){
      throw CannotUpdateCloudUserPresentException();
    }
    }

    Future<void> UpdatePassword({required String groupName, required String ownerId, required String newPassword}) async{
    final doc = await getCloudGroupDocument(groupName: groupName, ownerId: ownerId);
    await groupCloudList.doc(doc.id).update({
      passwordFieldName: newPassword
    });
    }

    Future<void> UpdateGroupName({required String groupName, required String ownerId, required String newName}) async{
      final doc = await getCloudGroupDocument(groupName: groupName, ownerId: ownerId);
      await groupCloudList.doc(doc.id).update({
        groupNameFieldName: newName
      });
    }

    Future<void> UpdateAdminList({required String groupName, required String ownerId, required String toAddId, required bool add}) async{
    final groupDoc = await getCloudGroupDocument(groupName: groupName, ownerId: ownerId);
    final adminList = groupDoc.get(adminIdFieldName) as List<dynamic>;
    if (!adminList.contains(toAddId) && add == true){
      adminList.add(toAddId);
      await groupCloudList.doc(groupDoc.id).update({
        adminIdFieldName: adminList
      });
    }
    else if (adminList.contains(toAddId) && add == false){
      adminList.remove(toAddId);
      await groupCloudList.doc(groupDoc.id).update({
        adminIdFieldName: adminList
      });
    }
    }

    //Creating a singleton
  static final FirebaseCloudStorage _singleCloudStorage = FirebaseCloudStorage.singleCloudStorage();

  FirebaseCloudStorage.singleCloudStorage();

  factory FirebaseCloudStorage() => _singleCloudStorage;

}
