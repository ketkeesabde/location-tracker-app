import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_tracking_app_iitg/Models/User.dart';

class Group {
  final String grpName;
  final List<dynamic> userUidList;
  final String docId;
  Group({required this.grpName, required this.userUidList, this.docId = ''});

  CollectionReference grpRef = FirebaseFirestore.instance.collection('groups');
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  Future<void> createGrp() async {
    DocumentReference randomDoc = grpRef.doc();
    await grpRef.doc(randomDoc.id).set({
      'grpName': grpName,
      'userUidList': userUidList,
      'docId': randomDoc.id,
    });
  }

  Future<List<User>> populateUsers() async {
    List<User> userList = <User>[];
    for (String uid in userUidList) {
      DocumentSnapshot snapshot = await userRef.doc(uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      User user = User(
          uid: data['uid'], name: data['fname'], imageUrl: data['imageUrl']);
      userList.add(user);
    }
    return userList;
  }

  Future<void> deleteUserFromGrp(String uid) async {
    userUidList.remove(uid);
    await grpRef
        .doc(docId)
        .set({'userUidList': userUidList}, SetOptions(merge: true));
  }
}
