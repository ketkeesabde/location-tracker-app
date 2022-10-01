import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_tracking_app_iitg/Models/Group.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchQuery = TextEditingController();
  late String grpName;

  bool isSnackBarActive = false;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  List<QueryDocumentSnapshot> _searchedUsernamesDoc = <QueryDocumentSnapshot>[];
  List<QueryDocumentSnapshot> _selectedUsernamesDoc = <QueryDocumentSnapshot>[];

  void _searchUsernameInDatabase(String text) async {
    List<QueryDocumentSnapshot> result = <QueryDocumentSnapshot>[];
    QuerySnapshot snapshot = await userCollection
        .where('fname',
            isGreaterThanOrEqualTo: text, isLessThanOrEqualTo: text + '\uf8ff')
        .get();
    snapshot.docs.forEach((doc) {
      result.add(doc);
    });
    setState(() {
      _searchedUsernamesDoc = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () async {

            if (!isSnackBarActive) {
              final snackbar = SnackBar(
                  duration: Duration(days: 1),
                  content: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Group Name',
                            labelStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              grpName = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            List<String> _selectedUsernamesUid = <String>[];
                            _selectedUsernamesDoc.forEach((doc) {
                              _selectedUsernamesUid.add(doc['uid']);
                            });
                            Group newGrp = Group(
                                grpName: grpName,
                                userUidList: _selectedUsernamesUid);
                            await newGrp.createGrp();
                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            setState(() {
                              isSnackBarActive = false;
                            });
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.forward))
                    ],
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              setState(() {
                isSnackBarActive = true;
              });
            }

          }),
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: _searchQuery,
              autofocus: true,
              decoration: InputDecoration(
                // add more decoration
                hintText: 'Search by username',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              onChanged: _searchUsernameInDatabase,
            ),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: _selectedUsernamesDoc
                  .map((item) => _buildChip(item, Color(0xFFff6666)))
                  .toList()
                  .cast<Widget>(),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _searchedUsernamesDoc.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.label),
                      title: Text(_searchedUsernamesDoc[index]['fname']),
                      // selected: _selectedDestination == 2,
                      onTap: () {
                        if (!_selectedUsernamesDoc
                            .contains(_searchedUsernamesDoc[index])) {
                          setState(() {
                            _selectedUsernamesDoc
                                .add(_searchedUsernamesDoc[index]);
                          });
                        }
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(QueryDocumentSnapshot doc, Color color) {
    String label = doc['fname'];
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      deleteIcon: Icon(Icons.close),
      onDeleted: () => _deletedSelected(doc),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  void _deletedSelected(QueryDocumentSnapshot doc) {
    setState(() {
      _selectedUsernamesDoc.remove(doc);
    });
  }
}
