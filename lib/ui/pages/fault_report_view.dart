import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory/ui/pages/dashboard_view.dart';
import 'package:inventory/ui/pages/otp_view.dart';
import 'package:inventory/widget/button_widget.dart';
import 'package:inventory/widget/text_field.dart';


class FaultReportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String Currentdate = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString();
    final amount = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Report Fault',
            style: TextStyle(
              color: Colors.white,
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
             Column(
                  children: <Widget>[


                    TextFieldWidget(
                      hintText: 'Part ID if Available',
                      prefixIconData: Icons.vpn_key,
                      maxlength: 20,
                      textColor: Colors.black,


                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFieldWidget(
                      hintText: 'Site Code',
                      textColor: Colors.black,
                      text: '1',
                      enabled:  false,
                      prefixIconData: Icons.not_listed_location,

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFieldWidget(
                      hintText: 'Current Date',
                      text: Currentdate,
                      prefixIconData: Icons.date_range,
                      maxlength: 20,
                      textColor: Colors.black,
                      enabled:  false,


                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFieldWidget(
                      hintText: 'Fault Description',
                      prefixIconData: Icons.description,
                      maxlength: 100,
                      box: true,
                      textColor: Colors.black,

                    ),
                    SizedBox(
                      height: 30.0,
                    ),







                  ],
                ),





            ],

      ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
        child: GestureDetector(
          onTap: ()
          {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OtpView())
            );
          },
          child: ButtonWidget(
            title: 'Report',
            hasBorder: false,
          ),
        ),
      ),
    
    );
  }
}