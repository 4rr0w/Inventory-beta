import 'package:Inventory/model/user_management.dart';
import 'package:Inventory/ui/pages/change_password.dart';
import 'package:Inventory/ui/pages/feedback_view.dart';
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
                    type == "User" ? "SITE : " + site : "Admin",
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
                  SizedBox(
                    height: 10.0,
                  ),

                  Text(
                    active ? "" : "Profile disabled",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
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
            leading: Icon(Icons.refresh),
            title: Text('Refresh'),
            onTap: () => {
              Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserManagement().handleAuth()))
          },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Change Password'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangePassword()))
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedbackView(site: site,email: email,)))
            },
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