import 'package:location_tracking_app_iitg/Models/Group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class GroupService {
  CollectionReference grpCollection =
      FirebaseFirestore.instance.collection('groups');
  String uid = _auth.currentUser!.uid;
  List<Group> _grpListFromSnapshot(QuerySnapshot snapshot) {
    List<Group> myGrp = <Group>[];
    snapshot.docs.forEach((doc) {
      Map<dynamic, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['userUidList'].contains(uid)) {
        myGrp.add(Group(
            grpName: data['grpName'],
            userUidList: data['userUidList'],
            docId: data['docId']));
      }
    });
    return myGrp;
  }

  Stream<List<Group>> get groups {
    return grpCollection.snapshots().map(_grpListFromSnapshot);
  }
}
