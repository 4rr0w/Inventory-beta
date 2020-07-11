
import 'package:flutter/material.dart';
import 'package:inventory/ui/pages/fault_report_view.dart';
import 'package:provider/provider.dart';

import 'model/home_model.dart';
import 'ui/pages/home_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => HomeView(),
          '/FaultReportView': (context) => FaultReportView(),

        },
      ),
    );
  }
}