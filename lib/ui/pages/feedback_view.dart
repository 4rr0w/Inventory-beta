import 'package:Inventory/widget/alert_dialog_widget.dart';
import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FeedbackView extends StatefulWidget {

  final String site;
  final String email;

  const FeedbackView({Key key, this.site,this.email}) : super(key: key);
  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {


  final _feedback = TextEditingController();
  final databaseReference = Firestore.instance;
  bool confirm = false;

  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  
  bool _nullFeedback = false;
  bool loading = false;

  _FeedbackViewState();


  _showToast(String message) async {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: message == "Cancelled" ? Colors.blueAccent:Colors.green,
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      barrierColor: Colors.white,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm to submit feedback',
            style: TextStyle(
                fontSize: 20
            ),),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('Confirm'),
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


  Future<void> submitFeedback() async{
    String date = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString();
    confirm = false;
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    await _showMyDialog();

    if(confirm) {
      await databaseReference.collection("Feedback")
          .document(timestamp.toString())
          .setData({
        'site': widget.site,
        'user-mail': widget.email,
        'feedback': _feedback.text,
        'date': date,
        'timestamp': timestamp,
      });
      _showToast("Feedback Submitted!");
    }
    else
      _showToast("Cancelled");


    setState(() {
      loading = false;
    });

    _feedback.text = "";

  }


  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('App Feedback',
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

                  SizedBox(
                    height: 10.0,
                  ),
                  TextFieldWidget(
                    controller: _feedback,
                    hintText: 'Feedback',
                    errortext:  _nullFeedback ? "This is required!" : null,
                    prefixIconData: Icons.description,
                    maxlength: 500,
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
              _nullFeedback = _feedback.text.isEmpty;

            });

            if(!_nullFeedback ) {

              setState(() {
                loading = true;
              });

              submitFeedback();

            }
          },
          child: ButtonWidget(
            title: 'Submit Feedback',
            hasBorder: false,
          ),
        ),
      ),

    );
  }
}