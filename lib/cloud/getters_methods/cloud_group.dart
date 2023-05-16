import 'package:cloud_firestore/cloud_firestore.dart';
import '../ccloud_group.dart';
import '../field_name.dart';

final groupCloudList = FirebaseFirestore.instance.collection("group");

//Get a specific cloud group
Future<CloudGroup> getCloudGroup({required String groupName, required String ownerId}) async{
  final groupDoc = await getCloudGroupDocument(
      groupName: groupName,
      ownerId: ownerId,
  );
  return CloudGroup(
      groupId: groupDoc.id,
      name: groupName,
      ownerName: groupDoc.get(ownerNameFieldName),
      password: groupDoc.get(passwordFieldName),
      ownerId: groupDoc.get(ownerIdFIeldName),
      adminUserList: groupDoc.get(adminIdFieldName),
      usersPresentList: groupDoc.get(usersPresentFieldName),
      usersNotPresentList: groupDoc.get(usersNotPresentFieldName)
  );
}

//Get a specific cloud group document
Future<QueryDocumentSnapshot<Map<String, dynamic>>> getCloudGroupDocument({required String groupName, required String ownerId}) async{
  return await groupCloudList
      .where(groupNameFieldName, isEqualTo: groupName)
      .where(ownerIdFIeldName, isEqualTo: ownerId).get().then(
          (document) => document.docs[0]
  );
}

//Get All cloud group document
Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllCloudGroupDocuments({String? groupName, required String ownerId}) async{
  return await groupCloudList
      .where(groupNameFieldName, isEqualTo: groupName)
      .where(ownerIdFIeldName, isEqualTo: ownerId).get().then(
          (document) => document.docs
  );
}

//Get All Cloud group using group name and owner name
Future<Stream<Iterable<CloudGroup>>> getAllCloudGroups({String? groupName, String? ownerName, String? ownerId}) async{
  try {
    if (groupName != null) {
      return await groupCloudList
          .where(groupNameFieldName, isEqualTo: groupName)
          .where(ownerNameFieldName, isEqualTo: ownerName).get().asStream().map(
              (queryDocument) =>
              queryDocument.docs.map(
                      (document) =>
                      CloudGroup(
                        groupId: document.id,
                        name: document.get(groupNameFieldName),
                        ownerName: ownerName,
                        password: document.get(passwordFieldName),
                        ownerId: document.get(ownerIdFIeldName),
                        adminUserList: document.get(adminIdFieldName),
                        usersPresentList: document.get(usersPresentFieldName),
                        usersNotPresentList: document.get(
                            usersNotPresentFieldName),
                      )
              ).toList()
      );
    }
    else {
      return await groupCloudList
          .where(ownerNameFieldName, isEqualTo: ownerName).get().asStream().map(
              (queryDocument) =>
              queryDocument.docs.map(
                      (document) {
                        return CloudGroup(
                          groupId: document.id,
                          name: document.get(groupNameFieldName),
                          ownerName: ownerName,
                          password: document.get(passwordFieldName),
                          ownerId: document.get(ownerIdFIeldName),
                          adminUserList: document.get(adminIdFieldName),
                          usersPresentList: document.get(usersPresentFieldName),
                          usersNotPresentList: document.get(
                              usersNotPresentFieldName),
                        );
                      }
              ).toList()
      );
    }
  } catch (e){
    print(e);
    throw e;
  }
}

//get document using groupId
Future<Stream<Iterable<CloudGroup>>> getCloudGroupDocumentUsingId({required String groupId}) async{
  return groupCloudList
      .where(groupIdFieldName, isEqualTo: groupId)
      .get().then(
          (documentSnapshot) => documentSnapshot.docs.map(
                  (document) => CloudGroup(
                      groupId: groupId,
                    name: document.get(groupNameFieldName),
                    ownerName: document.get(ownerNameFieldName),
                    password: document.get(passwordFieldName),
                    ownerId: document.get(ownerIdFIeldName),
                    adminUserList: document.get(adminIdFieldName),
                    usersPresentList: document.get(usersPresentFieldName),
                    usersNotPresentList: document.get(
                        usersNotPresentFieldName),
                  )
          ).toList()
  ).asStream();
}