import 'package:Inventory/model/user_management.dart';
import 'package:Inventory/widget/loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/model/home_model.dart';
import 'package:Inventory/ui/pages/dashboard_view.dart';
import 'package:Inventory/ui/pages/signup_view.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:Inventory/widget/wave_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {



  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _nullEmail = false;
  bool _invalidPass = false;
  bool loading = false;
  FlutterToast flutterToast;

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
          Icon(Icons.warning
            , color: Colors.red,),
          SizedBox(
            width: 15.0,
          ),
          Center(
            child: Expanded(
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.black),
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


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 50;
    final model = Provider.of<HomeModel>(context);

    Future<void> SignIn() async{
      try {
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text, password: _password.text)).user;
        setState(() {
          loading = false;
        });

        if (user != null) {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserManagement().handleAuth()),
          );

        }
        else{
          _showToast("Something went wrong.");
          setState(() {
            loading = false;
          });
        }

      }catch(e)
      {
        setState(() {
          loading = false;
        });
        _showToast(e.message);
      }
    }


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
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutQuad,
              top: keyboardOpen ? -size.height / 5 : 0.0,
              child: WaveWidget(
                size: size,
                yOffset: size.height / 3.0,
                color: keyboardOpen? Colors.blue : Colors.blue,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: keyboardOpen ? 50.0 : 100.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'Login',
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
              padding: EdgeInsets.fromLTRB(30.0,keyboardOpen ? 180.0 : 300.0,30.0, keyboardOpen ? 10.0 : 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextFieldWidget(
                    controller: _email,
                    errortext: _nullEmail ? "Invalid Email!" : null,
                    hintText: 'Email',
                    obscureText: false,
                    prefixIconData: Icons.email,

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFieldWidget(
                        controller: _password,
                        errortext: _invalidPass ? "" : null,
                        hintText: 'Password',
                        maxlength: 30,
                        obscureText: !model.isVisible,
                        prefixIconData: Icons.lock_outline,
                        suffixIconData: model.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Material(
                    elevation: 15.0,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(

                      onTap: () async{
                          setState(() {
                            _nullEmail = !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email.text);
                            _invalidPass= _password.text.isEmpty;

                          });

                      if (!_nullEmail && !_invalidPass) {
                        loading = true;
                        SignIn();
                      }
                      },
                      child: ButtonWidget(
                        title: 'Login',
                        hasBorder: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupView()),
                      );
                    },
                    child: ButtonWidget(
                      title: 'Sign Up',
                      hasBorder: true,
                    ),
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
