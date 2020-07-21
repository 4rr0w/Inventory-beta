
import 'package:Inventory/widget/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'failt_view.dart';

class FaultHistoryView extends StatefulWidget {

  final int site;
  final String type;

  const FaultHistoryView({Key key, this.site, this.type}) : super(key: key);

  @override
  _FaultHistoryViewState createState() => _FaultHistoryViewState(site, type);

}

class _FaultHistoryViewState extends State<FaultHistoryView> {
  final int site;
  final String type;
  final TextEditingController  _searchText = TextEditingController();



  _FaultHistoryViewState(this.site, this.type);

  bool searchPressed = false;

  var focusNode = new FocusNode();
  bool search = false;

  Stream dataList;

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }


  @override
  void initState() {
    if(site == 0)
      dataList = Firestore.instance.collection("Reports").orderBy('timestamp',descending: true).snapshots();
    else
      dataList = Firestore.instance.collection("Reports").where(
        'site',isEqualTo:site
      ).orderBy('timestamp',descending: true).snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    String searchText;


    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:30.0),
                    child: Text(
                      'Faults',
                      style: TextStyle(
                        fontSize: 25.0
                      ),
                    ),
                  ),

                  Container(
                    width: 200.0,
                    child: TextField(
//
                      focusNode: focusNode,
                      cursorColor: Colors.white,
                      controller: _searchText,
                      maxLines: 1,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.0,
                      ),

                      decoration:  InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                      ),

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      onPressed: (){
                        setState(() {
                          searchText = _searchText.text;

                        });
                      },
                      icon: Icon(CupertinoIcons.search),
                      iconSize: 30.0,

                    ),
                  ),
                ],
              ),

            ]),

      body: StreamBuilder <QuerySnapshot>(
        stream: dataList,

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)

        {
          if (!snapshot.hasData) return Loading(color: Colors.black);
          if (snapshot.data == null) return Card(
            child: Center(
              child: Text(
                  "Not Found",
                  style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 40.0
                  )
              ),
            ),
          );
          return ListView(
            children: snapshot.data.documents.map((document) {
              if ((document['site'] == _searchText.text
                    || (_searchText.text == document.documentID.substring(0,_searchText.text.length) && _searchText.text.length > 2)
                    || (_searchText.text == document["date"].toString().substring(0,_searchText.text.length)  && _searchText.text.length > 2)
                    || (_searchText.text == document["fault-status"].toString().substring(0,_searchText.text.length))
                  ))
                {
                return Padding(
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.blue,
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              FaultView(id: document.documentID , site: site, type: type)));
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
              } else
                return SizedBox(
                  height: 0,
                );
            }).toList(),
          ) ;
        },
      ),
      ),
    );
  }

}

