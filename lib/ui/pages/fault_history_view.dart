
import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaultHistoryView extends StatefulWidget {

  final int site;

  const FaultHistoryView({Key key, this.site}) : super(key: key);

  @override
  _FaultHistoryViewState createState() => _FaultHistoryViewState(site);

}

class _FaultHistoryViewState extends State<FaultHistoryView> {

  final  int site;

  _FaultHistoryViewState(this.site);


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: new Text("Fault History"),
    ),
    body: new FaultsList(site: site),
    );
  }

}


class FaultsList extends StatelessWidget {
  final int site;

  const FaultsList({Key key, this.site}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder (
      stream: site == 0 ? Firestore.instance.collection('Reports').snapshots() : Firestore.instance.collection('Reports').where('site',isEqualTo: site.toString()).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Loading();
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return Card(
              color: document['fault-status'] == 'Active' ? Colors.redAccent: Colors.green,
              child: new ListTile(
                onTap: (){

                },
                title: new Text(document['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),),
                subtitle: new Text(document['title']),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}