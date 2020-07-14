import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/ui/pages/dashboard_view.dart';
import 'package:Inventory/ui/pages/otp_view.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';


class FaultReportView extends StatefulWidget {
  @override
  _FaultReportViewState createState() => _FaultReportViewState();
}

class _FaultReportViewState extends State<FaultReportView> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  bool _nullTitle = false;
  bool _nullDescription = false;

  @override
  Widget build(BuildContext context) {
    String Currentdate = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString();


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
                      hintText: 'Site Code',
                      textColor: Colors.black,
                      enabled:  false,
                      prefixIconData: Icons.not_listed_location,

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFieldWidget(
                      hintText: 'Current Date',
                      prefixIconData: Icons.date_range,
                      maxlength: 20,
                      textColor: Colors.black,
                      enabled:  false,


                    ),
                    SizedBox(
                      height: 10.0,
                    ),

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
                      controller: _title,
                      errortext: _nullTitle ? "This is required!" : null,
                      hintText: 'Fault Title',
                      prefixIconData: Icons.title,
                      maxlength: 20,
                      textColor: Colors.black,


                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFieldWidget(
                      controller: _description,
                      hintText: 'Fault Description',
                      errortext:  _nullDescription ? "This is required!" : null,
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

            setState(() {
              _nullTitle = _title.text.isEmpty;
              _nullDescription = _description.text.isEmpty;

            });

            if((!_nullDescription && !_nullTitle)) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtpView())
              );
            }
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