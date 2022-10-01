import 'package:flutter/material.dart';
import 'package:location_tracking_app_iitg/Service/grp_service.dart';
import 'package:location_tracking_app_iitg/pages/Groups/groupList.dart';
import 'package:provider/provider.dart';
import 'package:location_tracking_app_iitg/Models/Group.dart';
import 'package:location_tracking_app_iitg/Service/Auth_Service.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  int _selectedDestination = 0;
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Group>>.value(
      initialData: [],
      value: GroupService().groups,
      child: Scaffold(
        drawer: drawerBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/search');
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('My Groups'),
        ),
        body: GroupList(),
      ),
    );
  }

  Widget drawerBar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 0, 5),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Profile'),
            selected: _selectedDestination == 0,
            onTap: () {
              selectDestination(0);
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.search),
          //   title: Text('Groups'),
          //   selected: _selectedDestination == 1,
          //   onTap: () {
          //     selectDestination(1);
          //     Navigator.of(context).pushNamed('/groups');
          //   },
          // ),

          // ListTile(
          //   leading: Icon(Icons.label),
          //   title: Text('Test Page'),
          //   selected: _selectedDestination == 2,
          //   onTap: () {
          //     selectDestination(2);
          //   },
          // ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Account settings',
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            selected: _selectedDestination == 3,
            onTap: () {
              selectDestination(3);
              authClass.signOut();
            },
          ),
        ],
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
}
