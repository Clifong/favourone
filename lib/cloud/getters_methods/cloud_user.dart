import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favourone/cloud/firebase_cloud_storage.dart';
import '../ccloud_group.dart';
import '../cloud_user.dart';
import '../field_name.dart';

final userCloudList = FirebaseFirestore.instance.collection("users");

//Get a specific cloud user
Future<CloudUser> getCloudUser({required String userId}) async{
  final cloudUserDoc = await getCloudUserDocument(userId: userId);
  final joinedGroup = (cloudUserDoc.get(joinedGroupsFieldName) as List<dynamic>)
      .map(
          (groupId) async {
            final groupDoc = await FirebaseCloudStorage().groupCloudList.doc(groupId).get();
            return CloudGroup(
              groupId: groupDoc.id,
              name: groupDoc.get(groupNameFieldName),
              ownerName: groupDoc.get(ownerNameFieldName),
              password: groupDoc.get(passwordFieldName),
              ownerId: groupDoc.get(ownerIdFIeldName),
              adminUserList: groupDoc.get(adminIdFieldName),
              usersPresentList: groupDoc.get(usersPresentFieldName),
              usersNotPresentList: groupDoc.get(
                  usersNotPresentFieldName),
            );
          }
  ).toList();
  return CloudUser(
      user_id: cloudUserDoc.get(userIdFieldName),
      username: cloudUserDoc.get(usernameFieldName),
      joinedGroups: joinedGroup,
  );
}

//Get All cloud user
Future<Stream<Iterable<CloudUser>>> getAllCloudUsers() async{
  return await userCloudList.get().asStream().map(
          (queryDocument) =>
          queryDocument.docs.map(
                  (document) =>
                  CloudUser(
                    user_id: document.get(userIdFieldName),
                    username: document.get(usernameFieldName),
                    joinedGroups: document.get(joinedGroupsFieldName)
                  )
          )
  );
}

//Get a specific cloud user document
Future<QueryDocumentSnapshot<Map<String, dynamic>>> getCloudUserDocument({required String userId}) async{
  try{
    return await userCloudList
        .where(userIdFieldName, isEqualTo: userId).get().then(
            (snapshot) => snapshot.docs[0]
    );
  }
  catch(e){
    throw e;
  }
}


