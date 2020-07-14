import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/model/home_model.dart';
import 'package:Inventory/ui/pages/login_view.dart';
import 'package:Inventory/ui/pages/otp_view.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:Inventory/widget/wave_widget.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _site = TextEditingController();
  final _password = TextEditingController();
  final _confPassword = TextEditingController();

  bool _nullName = false;
  bool _nullSite = false;
  bool _invalidPhone = false;
  bool _invalidMail = false;
  bool _invalidPass = false;
  bool _passNotMatched = false;


  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _site.dispose();
    _password.dispose();
    _confPassword.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 30;
    final model = Provider.of<HomeModel>(context);


    return Scaffold(
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
                    controller: _name,
                    errortext: _nullName ? "Can't be Empty." : null,
                    hintText: 'Full Name',
                    obscureText: false,
                    prefixIconData: Icons.person,

                  ),
                 SizedBox(
                   height: 10.0,
                 ),
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
                  TextFieldWidget(
                    controller: _phone,
                    hintText: 'Phone',
                    typeNum: true,
                    maxlength: 10,
                    obscureText: false,
                    prefixIconData: Icons.phone,
                    errortext: _invalidPhone ? "Invalid Number!" : null,

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
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
                                  _nullName = _name.text.isEmpty;
                                  _nullSite = _site.text.isEmpty;
                                  _invalidPhone = (_phone.text.length != 10);
                                  _invalidMail = !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email.text);
                                  _invalidPass = !(_password.text.length >5);
                                  _passNotMatched = (_password.text != _confPassword.text);
                                });
                                if (!_nullSite && !_nullName && !_invalidPass && !_invalidMail && !_invalidPhone && !_passNotMatched) {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => OtpView())
                                    );
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