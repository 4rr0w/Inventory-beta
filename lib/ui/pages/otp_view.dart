import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory/ui/pages/dashboard_view.dart';
import 'package:inventory/ui/pages/home_view.dart';
import 'package:inventory/widget/button_widget.dart';
import 'package:inventory/widget/text_field.dart';
import 'package:inventory/widget/wave_widget.dart';

class OtpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 30;

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
                    'OTP is sent to your Phone',
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
                        hintText: 'Enter OTP',
                        typeNum: true,
                        maxlength: 6,
                        obscureText: false,
                        prefixIconData: Icons.security,

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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Dashboard()),
                                  (r) => false
                          );
                        },
                        child: ButtonWidget(
                          title: 'Submit',
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
                          child: Text('Didn\'nt received OTP? Resend'))
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