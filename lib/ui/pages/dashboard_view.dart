import 'package:Inventory/ui/pages/fault_history_view.dart';
import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import 'package:Inventory/widget/nav_drawer.dart';
import 'package:Inventory/widget/wave_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fault_report_view.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String id,email,type;
  int site;
  final db = Firestore.instance;
  String userTitle;
  bool loading = false;
  bool active;

  FlutterToast flutterToast;

  @override
  void initState() {
    getUserInfo();
    super.initState();
    flutterToast = FlutterToast(context);
  }


  _showToast(String message) async {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning
            , color: Colors.deepOrange,),
          SizedBox(
            width: 15.0,
          ),
          Center(
            child: Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.black,
                ),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,


              ),
            ),
          ),

        ],
      ),
    );


    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }


  Future<void> getUserInfo()async{
    setState(() {
      loading = true;
    });

    var firebaseUser = await FirebaseAuth.instance.currentUser();
    id = firebaseUser.uid;
    email = firebaseUser.email;
    DocumentReference documentReference = await Firestore.instance.collection("Users").document(id);
    await documentReference.get().then((datasnapshot) async {
      if(datasnapshot.exists){
        site = await datasnapshot.data['site'];
        type = await datasnapshot.data['type'];
        active = await datasnapshot.data['active'];
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('email', email);
    prefs.setString('type', type);
    prefs.setBool('active', active);

    prefs.setInt("site",site);

    setState(() {
      loading = false;
    });

  }

  Column MyItems(IconData icon,String heading, Color color){
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Icon(
                    icon,
                    color: Colors.black,
                    size: 60.0,
                  ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Center(
                child: Text(heading,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                  color: color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,

                ),),
              ),
            ),

          ]
    );
  }

  Material inkwellsplash(IconData icon,String text,String route){
    return Material(
      elevation:  12.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          splashColor: Colors.blue,
          onTap: (){
            Navigator.pushNamed(
                context,
                route
            );
          },
          child: MyItems(icon,text,Colors.black)),
    );
  }
  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    final height =size.height;


    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      drawer: NavDrawer(
        site: site.toString(),
        email: email,
        type : type,
        active : active,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Dashboard',
        style: TextStyle(
          color: Colors.white,
        ),
        )
      ),
      body: Stack(
        children: [
//          Container(
//            height: size.height - 500,
//            color: Colors.white,
//          ),
//
//          AnimatedPositioned(
//            duration: Duration(milliseconds: 14000),
//            curve: Curves.easeOutQuad,
//            top: 0,
//            child: WaveWidget(
//              size: size,
//              yOffset: height / 1.5,
//              color: Colors.blue,
//            ),
//          ),
//          AnimatedPositioned(
//            duration: Duration(milliseconds: 14000),
//            curve: Curves.easeOutQuad,
//            top: 0,
//            child: WaveWidget(
//              size: size,
//              yOffset: height / 1.5,
//              color: Colors.blue,
//              xOffset: true,
//            ),
//          ),


          Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal:15.0,vertical:10.0),
              children: <Widget>[
                  Material(
                  elevation:  12.0,
                  shadowColor: Color(0x802196F3),
                  borderRadius: BorderRadius.circular(24.0),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(24.0),
                      splashColor: Colors.blue,
                      onTap: (){
                        site == 0 ? _showToast("Only a non-admin user can raise a fault!"):
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FaultReportView(site: site,))
                        );

                      },
                      child: MyItems(Icons.report,"Fault Reporting",Colors.black)),
                ),
                Material(
                  elevation:  12.0,
                  shadowColor: Color(0x802196F3),
                  borderRadius: BorderRadius.circular(24.0),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(24.0),
                      splashColor: Colors.blue,
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FaultHistoryView(site: site))
                        );

                      },
                      child: MyItems(Icons.history,"Fault History",Colors.black)),
                ),
                inkwellsplash(Icons.flag,"Fault Closure","/FaultReportView"),
                inkwellsplash(Icons.perm_phone_msg,"Customer Care","/FaultReportView"),
                 
                  ],

            ),
        ),]
      ),


    );
  }

}