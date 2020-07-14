import 'package:Inventory/model/user_management.dart';
import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final String site,email,type;
  final bool active;
  NavDrawer({Key key,this.site,this.email,this.type,this.active}): super(key: key);




  @override
  Widget build(BuildContext context) {
    



    return Drawer(
      child: ListView(

        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Column(
                children: [
                  Text(
                    type == "user"? "SITE : " + site : "Admin",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "TYPE : " + type,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "EMAIL : " + email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            decoration: BoxDecoration(
                color: Colors.blue,
                ),
          ),

          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async{
              await FirebaseAuth.instance.signOut();
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserManagement().handleAuth()),);
            },
          ),
        ],
      ),
    );
  }
}