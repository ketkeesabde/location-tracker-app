import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth _auth = FirebaseAuth.instance;

class User {
  static const tempUserImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/location-tracking-app-e5fd6.appspot.com/o/user.jpg?alt=media&token=09b622c8-e136-47eb-83ee-6e8b1c054322";
  final String uid;
  final String? name;
  final String? imageUrl;
  User({required this.uid, this.name = '', this.imageUrl = tempUserImageUrl});

  Future addUser() async {
    assert(_auth.currentUser != null);
    String uid = _auth.currentUser!.uid;
    String? name = _auth.currentUser!.displayName;
    String? imageUrl = _auth.currentUser!.photoURL;
    imageUrl ??= this.imageUrl;
    name ??= this.name;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    if (!documentSnapshot.exists) {
      try {
        await users.doc(uid).set({
          'uid': uid,
          'fname': name,
          'imageUrl': imageUrl,
        },SetOptions(merge: true));
        // print("user added to databse");
      } catch (e) {
        // for if some error occured
        print(e);
      }
    }
  }
}
