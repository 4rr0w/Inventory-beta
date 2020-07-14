import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:Inventory/ui/pages/dashboard_view.dart';
import 'package:Inventory/ui/pages/login_view.dart';

class UserManagement {
  Widget handleAuth() {
    return new StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged,
        builder:(BuildContext context, snapshot){
          if(snapshot.hasData){
            return Dashboard();
          }
          else
            return LoginView();
        }
        );
  }

}



