import 'package:Inventory/widget/loader_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:Inventory/ui/pages/dashboard_view.dart';
import 'package:Inventory/ui/pages/login_view.dart';

class UserManagement {
  Widget handleAuth() {
    return new StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged,
        builder:(BuildContext context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
//            FirebaseAuth.instance.signOut();
           return Loading();

         }
          if(snapshot.hasData){
            print('dash');
            return Dashboard();
          }
          return LoginView();
        }
        );
  }

}



