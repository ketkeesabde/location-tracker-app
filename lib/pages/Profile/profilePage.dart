import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_tracking_app_iitg/pages/Profile/edit_profile_page.dart';
import 'package:location_tracking_app_iitg/pages/Profile/widget/appbar_widget.dart';
import 'package:location_tracking_app_iitg/pages/Profile/widget/button_widget.dart';
import 'package:location_tracking_app_iitg/pages/Profile/widget/numbers_widget.dart';
import 'package:location_tracking_app_iitg/pages/Profile/widget/profile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_tracking_app_iitg/shared/loading.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late String name;
  late String imageUrl;

  Future<void> setUserData() async {
    final String uid = _auth.currentUser!.uid;
    DocumentSnapshot ds = await users.doc(uid).get();

    name = ds.get('fname');
    imageUrl = ds.get('imageUrl');
  }

  void setData(String name, String imageUrl) {
    setState(() {
      this.name = name;
      this.imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Loading(message: 'Loading...');
        }
        return Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: imageUrl,
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(name: name, imageUrl: imageUrl, setData: setData )),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(),
              // const SizedBox(height: 24),
              // Center(child: buildUpgradeButton()),
              // const SizedBox(height: 24),
              // NumbersWidget(),
              const SizedBox(height: 48),
              buildAbout(),
            ],
          ),
        );
      },
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            _auth.currentUser!.email!,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () {},
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'You can edit your profile here.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
