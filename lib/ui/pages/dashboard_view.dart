import 'package:flutter/material.dart';
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import 'package:inventory/widget/nav_drawer.dart';
import 'package:inventory/widget/wave_widget.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Material MyItems(IconData icon,String heading, Color color,String routeName){
    return Material(
        color: Colors.lightBlueAccent,
        elevation:  12.0,
        shadowColor: Color(0x802196F3),
        borderRadius: BorderRadius.circular(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Material (
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: 60.0,
                  ),
                )
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
        )
      );
  }

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    final height =size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavDrawer(),
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
          Container(
            height: size.height - 500,
            color: Colors.white,
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 14000),
            curve: Curves.easeOutQuad,
            top: 0,
            child: WaveWidget(
              size: size,
              yOffset: height / 1.5,
              color: Colors.blue,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 14000),
            curve: Curves.easeOutQuad,
            top: 0,
            child: WaveWidget(
              size: size,
              yOffset: height / 1.5,
              color: Colors.blue,
              xOffset: true,
            ),
          ),


          Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal:15.0,vertical:10.0),
              children: <Widget>[

                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            "/FaultReportView"
                        );
                      },
                      child: MyItems(Icons.report,"Fault Reporting",Colors.white,'/FaultReportView')),
                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            "/FaultReportView"
                        );
                      },
                      child: MyItems(Icons.history,"Fault History",Colors.white,'/FaultReportView')),
                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            "/FaultReportView"
                        );
                      },
                      child: MyItems(Icons.assistant_photo,"Fault Closure",Colors.white,'/FaultReportView')),
                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            "/FaultReportView"
                        );
                      },
                      child: MyItems(Icons.perm_phone_msg,"Customer Care",Colors.white,'/FaultReportView')),


                  ],

            ),
        ),]
      ),


    );
  }

}