import 'package:Inventory/model/home_model.dart';
import 'package:Inventory/widget/loader_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Inventory/widget/button_widget.dart';
import 'package:Inventory/widget/text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


class ChangePassword extends StatefulWidget {


  const ChangePassword({Key key}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _pass = TextEditingController();
  final _confpass = TextEditingController();
  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }


  bool _invalidPass = false;
  bool _passNotMatched = false;
  bool loading = false;




  _showToast(String message,{bool error : false}) async {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: error ? Colors.blue : Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(error? Icons.error : Icons.check
            , color: Colors.white,),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                ),
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
      toastDuration: Duration(seconds: 5),
    );
  }


  Future<void> changePass() async{

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.updatePassword(_pass.text).then((_){
        _showToast("Password Changed Successfully");
    }).catchError((error){
        _showToast("Please login again before trying to change password" , error : true);

    });

    _pass.text = "";
    _confpass.text = "";

    setState(() {
      loading = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Change Password',
            style: TextStyle(
              color: Colors.white,
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(

            children: <Widget>[
              SizedBox(
                height: 0.0,
              ),
              TextFieldWidget(
                controller: _pass,
                textColor: Colors.black,
                errortext: _invalidPass ? "Minimum length is 6" : null,
                hintText: ' New Password',
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
                controller: _confpass,
                textColor: Colors.black,
                errortext: (_passNotMatched && !_invalidPass) ? "Please enter same password!" : null,

                hintText: 'Confirm Password',
                obscureText: true,
                prefixIconData: Icons.lock_outline,
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
              _invalidPass = !(_pass.text.length >5);
              _passNotMatched = (_pass.text != _confpass.text);

            });

            if(!_invalidPass && !_passNotMatched) {

              setState(() {
                loading = true;
              });

              changePass();

            }
          },
          child: ButtonWidget(
            title: 'Submit',
            hasBorder: false,
          ),
        ),
      ),
    );
  }
}