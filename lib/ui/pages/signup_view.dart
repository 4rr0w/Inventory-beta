import 'package:Inventory/model/user_management.dart';
import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/model/home_model.dart';
import 'package:Inventory/ui/pages/login_view.dart';
import 'package:Inventory/ui/pages/reset_password_view.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:Inventory/widget/wave_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
//  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _site = TextEditingController();
  final _password = TextEditingController();
  final _confPassword = TextEditingController();
  final databaseReference = Firestore.instance;
  FlutterToast flutterToast;

  bool _nullSite = false;
//  bool _invalidPhone = false;
  bool _invalidMail = false;
  bool _invalidPass = false;
  bool _passNotMatched = false;
  bool loading = false;


  @override
  void dispose() {
//    _phone.dispose();
    _email.dispose();
    _site.dispose();
    _password.dispose();
    _confPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {

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
          Icon(Icons.check
            , color: Colors.green,),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
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


        ],
      ),
    );


    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }


  Future<void> signUp() async{

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text, password: _password.text);

    var firebaseUser = await FirebaseAuth.instance.currentUser();
    String id = firebaseUser.uid;

    await databaseReference.collection("Users")
        .document(id)
        .setData({
      'type': int.parse(_site.text) == 0 ? 'BEL Admin' : 'User' ,
      'site': int.parse(_site.text),
      'active': false,

    });


    _showToast("Account Created");

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserManagement().handleAuth()),

    );

  }
  catch(e){
    setState(() {
      loading = false;
    });
      _showToast(e.message);
  }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 30;
    final model = Provider.of<HomeModel>(context);


    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: size.height - 200,
              color: keyboardOpen? Colors.blue: Colors.white,
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 4000),
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
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
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

                 TextFieldWidget(
                    controller: _email,
                    hintText: 'Email',
                    obscureText: false,
                    prefixIconData: Icons.mail_outline,
                   errortext: _invalidMail ? "Invalid Email!" : null,

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
//                  TextFieldWidget(
//                    controller: _phone,
//                    hintText: 'Phone',
//                    typeNum: true,
//                    maxlength: 10,
//                    obscureText: false,
//                    prefixIconData: Icons.phone,
//                    errortext: _invalidPhone ? "Invalid Number!" : null,
//
//                  ),
//                  SizedBox(
//                    height: 10.0,
//                  ),
                  TextFieldWidget(
                    controller: _site,
                    errortext: _nullSite ? "Can't be Empty." : null,
                    hintText: 'Site Code',
                    typeNum: true,
                    maxlength: 2,
                    obscureText: false,
                    prefixIconData: Icons.not_listed_location,

                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFieldWidget(
                        controller: _password,
                        errortext: _invalidPass ? "Minimum length is 6" : null,
                        hintText: 'Password',
                        obscureText: !model.isVisible,
                        prefixIconData: Icons.lock_outline,
                        suffixIconData: model.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFieldWidget(
                        controller: _confPassword,
                        errortext: (_passNotMatched && !_invalidPass) ? "Please enter same password!" : null,

                        hintText: 'Confirm Password',
                        obscureText: true,
                        prefixIconData: Icons.lock_outline,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    children: [
                      Material(
                        elevation: 15.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                        onTap: ()
                              {
                                setState(() {
                                  _nullSite = _site.text.isEmpty;
//                                  _invalidPhone = (_phone.text.length != 10);
                                  _invalidMail = !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email.text);
                                  _invalidPass = !(_password.text.length >5);
                                  _passNotMatched = (_password.text != _confPassword.text);
                                });
                                if (!_invalidPass  && !_nullSite && !_invalidMail &&!_passNotMatched) {
                                  setState(() {
                                    loading = true;
                                  });
                                    signUp();
                                }
                              },
                          child: ButtonWidget(
                            title: 'Sign Up',
                            hasBorder: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      GestureDetector(
                          onTap: (){

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginView()),
                                    (r) => false
                            );

                          },
                          child: Text('Already have an account? login')),
                      SizedBox(
                        height: 5.0,
                      ),
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