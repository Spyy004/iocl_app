import 'package:flutter/cupertino.dart';

import '../utils/consts.dart';

class RequestStore extends ChangeNotifier {
  List<Map<String, dynamic>> requests = [];
  List<String> docIds = [];
  Future<List<Map<String, dynamic>>> getRequests() async {
    requests = [];
    final querySnapshot = await db
        .collection("request")
        .orderBy("name", descending: false)
        .get();
    for(var docSnapshot in querySnapshot.docs) {
      requests.add(docSnapshot.data());
    }
    return requests;
  }

  void updateApprovalStatus (String id) {
    db.collection('activeRequest').doc(id).delete();
    db.collection('request').doc(id).update({"status": "approved"});
    notifyListeners();
  }
  void rejectBypassRequest (String id) {
    db.collection('activeRequest').doc(id).delete();
    db.collection('request').doc(id).update({"status": "rejected"});
    notifyListeners();
  }
}