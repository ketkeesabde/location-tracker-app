import 'package:flutter/material.dart';
import 'package:location_tracking_app_iitg/Models/Group.dart';
import 'package:location_tracking_app_iitg/Models/User.dart';

class GroupProfile extends StatefulWidget {
  final Group grp;
  const GroupProfile({required this.grp, Key? key}) : super(key: key);

  @override
  _GroupProfileState createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.grp.grpName),
        ),
        body: FutureBuilder(
          future: widget.grp.populateUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              List<User> userList = snapshot.data as List<User>;
              return ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image.network(userList[index].imageUrl!),
                        title: Text(userList[index].name!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            widget.grp.deleteUserFromGrp(userList[index].uid);
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupProfile(grp: widget.grp)));
                          },
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
