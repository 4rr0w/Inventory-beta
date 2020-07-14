import 'package:flutter/material.dart';
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import 'package:Inventory/widget/nav_drawer.dart';
import 'package:Inventory/widget/wave_widget.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

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
                "/FaultReportView"
            );
          },
          child: MyItems(icon,text,Colors.black)),
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
                inkwellsplash(Icons.report,"Fault Reporting","/FaultReportView"),
                inkwellsplash(Icons.history,"Fault History","/FaultReportView"),
                inkwellsplash(Icons.flag,"Fault Closure","/FaultReportView"),
                inkwellsplash(Icons.perm_phone_msg,"Customer Care","/FaultReportView"),
                 
                  ],

            ),
        ),]
      ),


    );
  }

}