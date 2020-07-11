import 'package:flutter/material.dart';


class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;


  ButtonWidget({
    this.title, this.hasBorder,   });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation:  10.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(10.0),
        child: Ink(
          decoration: BoxDecoration(
            color: hasBorder ? Colors.white: Colors.cyan,
            borderRadius: BorderRadius.circular(10.0),



          ),


          child: InkWell(
            splashColor: Colors.greenAccent,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 50.0,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  )
                ),
              ),
            ),
          ),
        ),
      );
  }
}
