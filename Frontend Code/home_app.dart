import 'package:flutter/material.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeApp extends StatelessWidget {
  final DataInfo dataHomePage2;
  HomeApp({this.dataHomePage2});

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
            dataHomePage2.studentName + '!',
            style: GoogleFonts.bitter(
              textStyle: TextStyle(
                  fontSize: 40.0, height: 1.3, color: Colors.grey[700]),
            ),
            maxLines: 1,
          ),
          Text(
            "Grade: " + dataHomePage2.studentGrade,
            style: GoogleFonts.ibmPlexSans(
              textStyle: TextStyle(
                  fontSize: 25.0, height: 3.0, color: Colors.grey[700]),
            ),
          ),
          Text(
            "ID: " + dataHomePage2.studentID,
            style: GoogleFonts.ibmPlexSans(
              textStyle: TextStyle(
                  fontSize: 25.0, height: 1.4, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
