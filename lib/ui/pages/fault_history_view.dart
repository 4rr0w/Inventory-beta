
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
      stream: site == 0 ? Firestore.instance.collection('Reports').orderBy('timestamp',descending: true).snapshots() : Firestore.instance.collection('Reports').where('site',isEqualTo: site.toString()).orderBy('timestamp',descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Loading(color: Colors.black);
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
              child: Card(
                elevation: 5,
                shadowColor: Colors.blue,
                color: Colors.white,
                child: InkWell(
                  onTap: (){

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[

                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [

                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Fault Id :  ",
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 17.0
                                  )
                              ),

                                Text(
                                    document.documentID,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    )
                                ),

                              ]
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right:30.0),
                              child: Text(
                                    document['fault-status'],
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue[800],

                                    )
                                ),
                            ),


                          ]
                        ),

                        SizedBox(
                          height: 3.0,
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "Created on :  ",
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontSize: 17.0
                                      )
                                  ),

                                  Text(
                                      document['date'],
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      )
                                  ),

                                ]
                            ),


                            site == 0 ? Padding(
                              padding: const EdgeInsets.only(right:30.0),
                              child: Text(
                                  document['site'],
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[800],

                                  )
                              ),
                            ) : Container(),
                          ],
                        ),

                        SizedBox(
                          height: 3.0,
                        ),

                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  "Title :  ",
                                  style: TextStyle(
                                      color: Colors.blue[800],
                                      fontSize: 17.0
                                  )
                              ),

                              Expanded(
                                child: Text(
                                    document['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      

                                    )
                                ),
                              ),

                            ]
                        ),



                      ]
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}