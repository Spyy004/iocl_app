import 'package:flutter/cupertino.dart';

import '../utils/consts.dart';

class AdminStore extends ChangeNotifier {
  List<Map<String, dynamic>> users = [];
  Future<List<Map<String, dynamic>>> getUsers() async {
    List<Map<String, dynamic>> dummyx = [];
    final querySnapshot = await db
        .collection("user")
        .orderBy("name", descending: false)
        .get();
    for(var docSnapshot in querySnapshot.docs) {
      dummyx.add(docSnapshot.data());
    }
    return dummyx;
  }

  Future<void> refreshData () async {
    getUsers();
    notifyListeners();
  }
  void addEmployee(String name ,String emailId, String empCode, String role) {
    print(role);
    final employee = <String, dynamic>{
      "name": name,
      "emailId": emailId,
      "createdAt": DateTime.now(),
      "empCode": empCode,
      "role": role
    };

    db
        .collection("user")
        .doc(empCode + name + emailId)
        .set(employee)
        .onError((e, _) => print("Error writing document: $e"));
    return;
  }

  void deleteEmployee(String empCode, String name, String emailId) {
    db.collection('user').doc(empCode + name + emailId).delete();
    notifyListeners();
  }

  void editEmployee(Map<String, dynamic> user, String newName) async {
    final userData =  await db.collection('user').doc(user['empCode'] + user['name'] + user['emailId']).get();
    if(userData.exists) {
      db.collection('user').doc(user['empCode']).set(userData.data()!);
      db.collection('user').doc(user['empCode']).update(
          {
            'emailId': newName
          });
      db.collection('user').doc(user['empCode'] + user['name'] + user['emailId']).delete();
    }
    else {
      db.collection('user').doc(user['empCode']).update(
          {
            'emailId': newName
          });
    }
  }
}