import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/ui/pages/dashboard_view.dart';
import 'package:Inventory/ui/pages/reset_password_view.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FaultReportView extends StatefulWidget {

  final int site;

  const FaultReportView({Key key, this.site}) : super(key: key);
  @override
  _FaultReportViewState createState() => _FaultReportViewState(site);
}

class _FaultReportViewState extends State<FaultReportView> {

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _site = TextEditingController();
  final _date = TextEditingController();
  final _partId = TextEditingController();
  final databaseReference = Firestore.instance;

  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }


  bool _nullTitle = false;
  bool _nullDescription = false;
  final  int site;
  bool loading = false;

  _FaultReportViewState(this.site);


  _showToast(String message) async {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check
            , color: Colors.white,),
          SizedBox(
            width: 15.0,
          ),
          Center(
            child: Expanded(
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.white,
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
      toastDuration: Duration(seconds: 2),
    );
  }


  Future<void> publishReport() async{
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    await databaseReference.collection("Reports")
        .document(timestamp.toString()+site.toString())
        .setData({
      'site': _site.text,
      'title': _title.text,
      'description':  _description.text,
      'date': _date.text,
      'bel-remark': '',
      'site-remark': '',
      'closing-date': '',
      'fault-status': 'Active',
      'part-id': _partId.text,
      'timestamp':  timestamp,
    });

    setState(() {
      loading = false;
    });

    _showToast("Fault Report Submitted!");

    _title.text = "";
    _description.text = "";
    _partId.text = "";


  }
  @override
  Widget build(BuildContext context) {
    String Currentdate = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString();

    _site.text = site.toString();
    _date.text = Currentdate;
    return loading ? Loading() : Scaffold(
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
                      controller: _site,
                      hintText: 'Site Code',
                      textColor: Colors.black,
                      enabled:  false,
                      prefixIconData: Icons.not_listed_location,

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFieldWidget(
                      controller: _date,
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
                      controller: _partId,
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
                      maxlength: 70,
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

              setState(() {
                loading = true;
              });

              publishReport();

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