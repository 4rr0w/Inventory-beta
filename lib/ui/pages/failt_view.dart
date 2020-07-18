import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FaultView extends StatefulWidget {

  final String id;
  final int site;
  final String type;

  const FaultView({Key key, this.id, this.site, this.type}) : super(key: key);
  @override
  _FaultViewState createState() => _FaultViewState();
}

class _FaultViewState extends State<FaultView> {



  final _title = TextEditingController();
  final _description = TextEditingController();
  final _site = TextEditingController();
  final _date = TextEditingController();
  final _partId = TextEditingController();
  final _belRemark = TextEditingController();
  final _userRemark = TextEditingController();
  final _faultActive = TextEditingController();
  String usertype;

  final databaseReference = Firestore.instance;
  bool confirm = false;

  FlutterToast flutterToast;

  @override
  void initState() {
    getUserInfo();
    super.initState();
    flutterToast = FlutterToast(context);
  }


  bool loading = false;




  _showToast(String message,{bool error : false}) async {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: error ? Colors.red : Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(error ? Icons.report : Icons.check
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

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      barrierColor: Colors.white,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please confirm to continue',
            style: TextStyle(
                fontSize: 20
            ),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message,
                    style: TextStyle(
                        fontSize: 20
                    ),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text("Confirm"),
              color: Colors.green,
              onPressed: () {
                confirm = true;
                Navigator.of(context).pop();
              },
            ),
          ],
          elevation: 25,
        );
      },
    );
  }

  Future<void> saveFault() async{
    setState(() {
      loading = true;
    });
    try {
      DocumentReference documentReference = await Firestore.instance.collection(
          "Reports").document(widget.id);
      await documentReference.updateData(<String, String>{
        "bel-remark": _belRemark.text,
        "site-remark": _userRemark.text,
      }
      );

      _showToast("Saved");
    }
    catch(e){
    _showToast(e.message);
    }

    setState(() {
      loading = false;
    });


  }

  Future<void> closeReport() async{
    setState(() {
      loading = true;
    });

    try {
      DocumentReference documentReference = await Firestore.instance.collection(
          "Reports").document(widget.id);
      await documentReference.updateData(<String, String>{
        "fault-status": 'Closed',
      }
      );
    }catch(e){
      _showToast(e.message, error: true);
    }

    setState(() {
      loading = false;
    });


  }

  Future<void> cancelReport() async{
    setState(() {
      loading = true;
    });

    try {
      DocumentReference documentReference = await Firestore.instance.collection(
          "Reports").document(widget.id);
      await documentReference.updateData(<String, String>{
        "fault-status": 'Cancelled',
      }
      );
    }catch(e){
      _showToast(e.message, error: true);
    }

    setState(() {
      loading = false;
    });


  }

  Future<void> getUserInfo() async{
    setState(() {
      loading = true;
    });

    DocumentReference documentReference = await Firestore.instance.collection("Reports").document(widget.id);
    await documentReference.get().then((datasnapshot) async {
      if(datasnapshot.exists){
        _site.text = await datasnapshot.data['site'];
        _description.text = await datasnapshot.data['type'];
        _date.text = await datasnapshot.data['date'];
        _partId.text = await datasnapshot.data['part-id'];
        _title.text = await datasnapshot.data['title'];
        _description.text = await datasnapshot.data['description'];
        _belRemark.text = await datasnapshot.data['bel-remark'];
        _userRemark.text = await datasnapshot.data['site-remark'];
        _faultActive.text = await datasnapshot.data['fault-status'];

      }
    });

    setState(() {
      loading = false;
    });

  }
  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Fault ID - ' + widget.id,
            style: TextStyle(
              color: Colors.white,
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Site : " +  _site.text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.1,
                          ),
                        ),

                        Text(
                          "Reported on : " + _date.text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.1,
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Text(
                      "Part ID : "  + (_partId.text == "" ? "Not Applicable" : _partId.text),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _partId.text == "" ? FontWeight.w300 : FontWeight.w500,
                        letterSpacing: 1.2,

                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child:
                    Text(
                      "Title : " ,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                        height: 1.3,
                      ),
                    ),

                  ),

                  SizedBox(
                    height: 5.0,
                  ),

                  Container(
                    padding: const EdgeInsets.only(left:40.0),
                    child:  Expanded(
                      child: Text(
                        _title.text,
                        maxLines: 40,
                        overflow: TextOverflow.fade,


                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:  FontWeight.w400,
                          letterSpacing: 1.2,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                      child:
                        Text(
                          "Description : " ,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.1,
                            height: 1.3,
                          ),
                        ),

                  ),

                  SizedBox(
                    height: 5.0,
                  ),

                  Container(
                      padding: const EdgeInsets.only(left:40.0),
                    child:  Expanded(
                      child: Text(
                        _description.text,
                        maxLines: 40,
                        overflow: TextOverflow.fade,


                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:  FontWeight.w400,
                          letterSpacing: 1.2,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),

                  TextFieldWidget(
                    controller: _belRemark,
                    textColor: Colors.black,
                    hintText: 'BEL Remark',
                    maxlength: 2,
                    obscureText: false,
                    prefixIconData: Icons.feedback,
                    enabled: ((widget.site != 0) || ( widget.type == "SuperUser"))? false : (true && _faultActive.text == 'Active'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),


                  TextFieldWidget(
                    controller: _belRemark,
                    textColor:  Colors.black,
                    hintText: 'Site Remark',
                    maxlength: 2,
                    obscureText: false,
                    prefixIconData: Icons.feedback,
                    enabled: (widget.site == 0 || _belRemark.text == '' || ( widget.type == "Super User")) ? false : (true && _faultActive.text == 'Active'),
                  ),





          ],
              ),

        ),
      ),
      bottomNavigationBar: (_faultActive.text != 'Active' || widget.type == 'Super User') ? MaterialButton(
        onPressed: (){},
           child: Text(
             'Report ' + _faultActive.text,
           style: TextStyle(
             fontSize: 20
           ),),
      ) : Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child:Container(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
        children: [
              MaterialButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                            widget.site == 0 ? "Close Issue" : 'Cancel',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                           ),
                         ),
                  ),
                elevation: 10,

                splashColor: Colors.black,
                color: Colors.red[700],
                disabledColor: Colors.grey,
                onPressed: (_userRemark.text == "" && widget.site == 0) ? null : () async {
                    if(widget.site == 0){
                      confirm = false;
                      await _showMyDialog("Close this report?");
                      if(confirm){
                        closeReport();
                      }
                    }
                    else{
                      confirm = false;
                      await _showMyDialog("Cancel this Report?");
                      if(confirm){
                        cancelReport();
                      }
                    }
                    getUserInfo();
                },
              ),

              MaterialButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                elevation: 10,
                splashColor: Colors.black,
                color: Colors.green[900],
                disabledColor: Colors.red[300],
                onPressed: () async {
                  confirm = false;
                  await _showMyDialog("Save this Remark?");
                  if(confirm){
                  saveFault();

                  }
                },
              ),

            ],

        ),
        ),
      ),



    );
  }
}