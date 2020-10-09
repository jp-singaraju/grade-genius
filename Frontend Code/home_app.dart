import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyHomeApp extends StatefulWidget {
  final dataHomePage2;
  MyHomeApp({this.dataHomePage2});

  @override
  HomeApp createState() => HomeApp();
}

class HomeApp extends State<MyHomeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Align(
              alignment: Alignment.center,
            ),
          ),
          Text(
            'Welcome,',
            style: GoogleFonts.asap(
              textStyle: TextStyle(
                  fontSize: 65.0, height: 2.7, color: Colors.grey[850]),
            ),
          ),
          AutoSizeText(
            widget.dataHomePage2.studentName + '!',
            style: GoogleFonts.bitter(
              textStyle: TextStyle(
                  fontSize: 40.0, height: 1.3, color: Colors.grey[700]),
            ),
            maxLines: 1,
          ),
          Text(
            "Grade: " + widget.dataHomePage2.studentGrade,
            style: GoogleFonts.ibmPlexSans(
              textStyle: TextStyle(
                  fontSize: 25.0, height: 3.0, color: Colors.grey[700]),
            ),
          ),
          Text(
            "User: " + widget.dataHomePage2.user,
            style: GoogleFonts.ibmPlexSans(
              textStyle: TextStyle(
                  fontSize: 25.0, height: 1.4, color: Colors.grey[700]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Text(widget.dataHomePage2.newAssignments.toString()),
          Text(widget.dataHomePage2.newScores.toString()),
          Text(widget.dataHomePage2.newClasses.toString()),
        ],
      ),
    );
  }
}
