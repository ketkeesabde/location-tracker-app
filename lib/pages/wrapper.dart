import 'package:flutter/material.dart';
import 'package:location_tracking_app_iitg/pages/Groups/groups.dart';
import 'package:location_tracking_app_iitg/pages/HomePage.dart';
import 'package:location_tracking_app_iitg/pages/Authenticate/SignInPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return SignInPage();
    } else {
      // return HomePage();
      return Groups();
    }
  }
}
