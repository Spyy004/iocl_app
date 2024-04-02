import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/consts.dart';

class DashboardStore extends ChangeNotifier {
  List<bool> selectedItems = List.generate(20, (index) => false);
  List<Map<String, dynamic>> selectedUsers = [];
  List<Map<String, dynamic>> randomizedUsers = [];
  List<Map<String, dynamic>> users = [];
  int selectedReason = -1;
  int noOfWorkersToTest = 0;
  Future<List<Map<String, dynamic>>> getUsers() async {
    users = [];
    final querySnapshot = await db
        .collection("user")
        .get();
    for(var docSnapshot in querySnapshot.docs) {
      users.add(docSnapshot.data());
    }
    selectedItems = List.generate(users.length, (index) => false);
    return users;
  }

  void toggleSelection(int index, Map<String, dynamic>? user) {
    selectedItems[index] = !selectedItems[index];
    if(selectedItems[index]) {
      selectedUsers.add(user!);
    }
    else {
      selectedUsers.remove(user);
    }
    notifyListeners();
  }

  // void selectAllAndRandomizeUsers() {
  //     int idx = 0;
  //     for (var element in selectedItems) {
  //       element = !element;
  //       if(element) {
  //         selectedUsers.add(users[idx]);
  //       }
  //       else {
  //         selectedUsers.remove(users[idx]);
  //       }
  //       idx++;
  //     }
  //     notifyListeners();
  //   //  randomizeUsers();
  // }

  void randomizeUsers() {
    if(randomizedUsers.isNotEmpty){
      return;
    }
    randomizedUsers = [];
    noOfWorkersToTest = (selectedUsers.length * 0.1).ceil();
    List<dynamic> clonedUsers = List.from(selectedUsers);
    for (int i = 0; i < noOfWorkersToTest; i++) {
      int randIndex = Random().nextInt(clonedUsers.length);
      randomizedUsers.add(clonedUsers.removeAt(randIndex));
    }
  }

  Future<bool> checkValidity() async {
    final querySnapshot = await db
        .collection("activeRequest")
        .get();
    return querySnapshot.docs.isEmpty ;
  }

  Future<bool> checkCooldown() async {
    final timeQuerySnapshot = await db.collection("cooldown").doc("test").get();
    final timeDoc = timeQuerySnapshot.data();
    dynamic createdAt = timeDoc?['timer'].toDate();
    final currDate = DateTime.now();
    Duration oneHour = Duration(hours: 1);
    final timeDiff = currDate.difference(createdAt).abs();
    return (timeDiff > oneHour);
  }

  Future<void> sendBypassRequest(String reason, dynamic user) async{
    String name = user['name'];
  //  print(user);
    final byPassId = name + DateTime.now().toLocal().toString();
    final employee = <String, dynamic>{
      "name": name,
      "id": byPassId ,
      "createdAt": DateTime.now(),
      "reason": reason,
      "status": "pending",
      "createdBy": loggedInUser?['name']
    };

    await db
        .collection("request")
        .doc(byPassId)
        .set(employee);

    await db
        .collection("activeRequest")
        .doc(byPassId)
        .set(employee);
    print(users);
    int index = users.indexOf(user);
    toggleSelection(index, user);
  }

  void emptyRandomizedUsers (user) {
    randomizedUsers.remove(user);
    print(randomizedUsers);
    notifyListeners();
  }

  void toggleSelectedReason (idx)  {
    selectedReason = idx;
    notifyListeners();
  }

  Future<bool> scheduleTest()async {

    if (randomizedUsers.length < noOfWorkersToTest) {
      showGenericToast("Please Randomize again");
      return false;
    }
    else {
      final doc = await db
          .collection("test")
          .add({
        "testId": DateTime.now(),
        "users": randomizedUsers
      });
      if(doc.id.isNotEmpty) {
          await db.collection("cooldown").doc("test").set({
            "timer": DateTime.now()
          });
          return true;
      }
      return false;
    }

  }

  void clearDataAfterSchedule() {
    print("YES HERE");
    randomizedUsers.clear();
    selectedUsers.clear();
    selectedItems = List.generate(20, (index) => false);
    showGenericToast("Test Scheduled Successfully.");
    notifyListeners();
  }
}