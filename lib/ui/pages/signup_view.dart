import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory/model/home_model.dart';
import 'package:inventory/ui/pages/home_view.dart';
import 'package:inventory/ui/pages/otp_view.dart';
import 'package:inventory/widget/button_widget.dart';
import 'package:inventory/widget/text_field.dart';
import 'package:inventory/widget/wave_widget.dart';
import 'package:provider/provider.dart';

class SignupView extends StatelessWidget {
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
                    hintText: 'Full Name',
                    obscureText: false,
                    prefixIconData: Icons.person,

                  ),
                 SizedBox(
                   height: 10.0,
                 ),
                 TextFieldWidget(
                    hintText: 'Email',
                    obscureText: false,
                    prefixIconData: Icons.mail_outline,

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFieldWidget(
                    hintText: 'Phone',
                    typeNum: true,
                    maxlength: 10,
                    obscureText: false,
                    prefixIconData: Icons.phone,

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFieldWidget(
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
                        hintText: 'Password',
                        obscureText: model.isVisible ? false : true,
                        prefixIconData: Icons.lock_outline,
                        suffixIconData: model.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFieldWidget(
                        hintText: 'Confirm Password',
                        obscureText: model.isVisible ? false : true,
                        prefixIconData: Icons.lock_outline,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                      onTap: ()
                            {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OtpView())
                            );
                            },
                        child: ButtonWidget(
                          title: 'Sign Up',
                          hasBorder: false,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(
                              context,
                                MaterialPageRoute(builder: (context) => HomeView()),
                                (r) => false
                            );
                          },
                          child: Text('Already have an account? login'))
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