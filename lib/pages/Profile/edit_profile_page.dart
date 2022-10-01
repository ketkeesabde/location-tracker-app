import 'package:flutter/material.dart';
import 'package:location_tracking_app_iitg/pages/Profile/widget/appbar_widget.dart';
import 'package:location_tracking_app_iitg/pages/Profile/widget/profile_widget.dart';
import 'package:location_tracking_app_iitg/pages/Profile/widget/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  final String name, imageUrl;
  final Function setData;
  EditProfilePage(
      {required this.name, required this.imageUrl, required this.setData});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String name, imageUrl;
  File? _image;

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final picker = ImagePicker();

  Future<void> modifyUserDetails() async {
    String uid = _auth.currentUser!.uid;
    DocumentReference documentReference = users.doc(uid);

    await documentReference.set({
      'uid': uid,
      'fname': name,
      'imageUrl': imageUrl,
    });
    // print("edited");
  }

  Future? uploadImagetoFirebase(BuildContext context) async {
    if (_image == null) {
      print("No image selected");
    } else {
      String fileName = basename(_image!.path);
      UploadTask task = FirebaseStorage.instance
          .ref('assets/images/$fileName')
          .putFile(_image!);

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Snapshot state: ${snapshot.state}'); // paused, running, complete
        print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
      }, onError: (Object e) {
        // setState(() {
        //   loading = false;
        // });
        print(e); // FirebaseException
      });

      task.then((TaskSnapshot snapshot) {
        print('Upload complete!');
      }).catchError((Object e) {
        print(e); // FirebaseException
      });
      String? imageUrl = await (await task).ref.getDownloadURL();
      setState(() {
        this.imageUrl = imageUrl;
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    imageUrl = widget.imageUrl;
    print('initialized name = $name && imageUrl = $imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: imageUrl,
            isEdit: true,
            onClicked: () async {
              await getImage();
              await uploadImagetoFirebase(context);
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: name,
            onChanged: (name) {
              print('newName = $name');
              this.setState(() {
                this.name = name;
              });
            },
          ),
          const SizedBox(height: 24),
          // TextFieldWidget(
          //   label: 'Email',
          //   text: ' email of user',
          //   onChanged: (email) {},
          // ),
          // const SizedBox(height: 24),
          // TextFieldWidget(
          //   label: 'About',
          //   text: 'somthing about the user',
          //   maxLines: 5,
          //   onChanged: (about) {},
          // ),
          TextButton(
              onPressed: () async {
                await modifyUserDetails();
                widget.setData(name, imageUrl);
                Navigator.pop(context);
              },
              child: Text('Upload'))
        ],
      ),
    );
  }
}
