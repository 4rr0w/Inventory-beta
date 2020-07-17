import 'package:flutter/material.dart';


class CustomAlertDialog extends StatefulWidget {
  final String reportId;

  const CustomAlertDialog({Key key, this.reportId}) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm?"),
      content: Text("Your report Id will be : " + widget.reportId),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: (){
                return false;
          },
        ),
        FlatButton(
          child :  Text("Submit"),
          onPressed: (){
            return true;
          },
          color: Colors.blueAccent,
          textColor: Colors.white,
        ),

      ],
    );
  }
}
