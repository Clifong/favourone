import 'package:favourone/cloud/getters_methods/cloud_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../cloud/cloud_user.dart';

class NormalUserCard extends StatelessWidget {
  final String userId;
  final bool isPresentOrNot;

  const NormalUserCard({
    required this.userId,
    required this.isPresentOrNot,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCloudUser(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cloudUser = snapshot.data as CloudUser;
            return Card(
                color: isPresentOrNot == true ? Colors.green : Colors.red,
                child: ListTile(
                  leading: const Icon(Icons.person, size: 30.0,),
                  title: Text("username: ${cloudUser.username}",
                      style: const TextStyle(fontSize: 20.0)),
                  subtitle: Text(isPresentOrNot == true ? "Present" : "Absent"),
                ));
          } else {
            return const Text("");
          }
        });
  }
}
