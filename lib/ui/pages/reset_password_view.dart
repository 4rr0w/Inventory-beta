import 'package:Inventory/model/user_management.dart';
import 'package:Inventory/widget/loader_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/ui/pages/dashboard_view.dart';
import 'package:Inventory/ui/pages/login_view.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:Inventory/widget/wave_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final _email = TextEditingController();

  bool _invalidemail = false;
  bool loading = false;

  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  _showToast(String message, IconData icon, Color color) async {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon
            , color: color),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.black),
              overflow: TextOverflow.fade,
              maxLines: 2,
              softWrap: true,


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

  Future<void> SendLink() async{

    try{

      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
      _showToast("Password reset link sent",Icons.check, Colors.green);
      setState(() {
        loading = false;
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserManagement().handleAuth()),
              (r) => false
      );

    }catch(e){
      setState(() {
        loading = false;
      });
      _showToast(e.message,Icons.warning, Colors.red);
    }


  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 30;

    return  Scaffold(
      appBar:new AppBar(
            title: new Text("Forgot Password")
      ),

      backgroundColor: Colors.blue,
      body: loading ? Loading() : SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: size.height - 200,
              color: keyboardOpen? Colors.blue: Colors.white,
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutQuad,
              top: keyboardOpen ? -size.height / 3.0 : 0.0,
              child: WaveWidget(
                size: size,
                yOffset: size.height / 4.9,
                color: keyboardOpen? Colors.blue : Colors.blue,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: keyboardOpen ? 40.0 : 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'An email will be sent to your email',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0,keyboardOpen ? 120.0 : 170.0,30.0, keyboardOpen ? 10.0 : 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFieldWidget(
                        controller: _email,
                        errortext: _invalidemail ? "Invalid Email!" : null,
                        hintText: 'Email',
                        obscureText: false,
                        prefixIconData: Icons.mail,

                      ),

                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _invalidemail = !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email.text);

                          });

                          if (!_invalidemail){
                            setState(() {
                              loading = true;
                            });
                            SendLink();
                          }

                        },
                        child: ButtonWidget(
                          title: 'Send Email',
                          hasBorder: false,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
//                      GestureDetector(
//                          onTap: (){
//                            Navigator.pushAndRemoveUntil(
//                                context,
//                                MaterialPageRoute(builder: (context) => LoginView()),
//                                    (r) => false
//                            );
//                          },
//                          child: Text('Didn\'t received the link? Resend',
//                          style: TextStyle(
//                            fontSize: 14,
//                            color: Colors.white,
//                          ),))
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}