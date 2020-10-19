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
  var newGrades;

  @override
  Widget build(BuildContext context) {
    int assignments = widget.dataHomePage2.newAssignments.length;
    if (assignments > 0) {
      newGrades = Expanded(
        child: Container(
          width: 350,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.cyan[100],
          ),
          child: ListView.builder(
            itemCount: widget.dataHomePage2.newAssignments.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 7.5, left: 10, right: 10),
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[600].withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                      color: Colors.cyan[50],
                      border: Border.all(
                        color: Colors.blueGrey[900],
                        width: 2.6,
                      ),
                      borderRadius: new BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    padding: EdgeInsets.all(4.5),
                    child: ListTile(
                      title: AutoSizeText(
                        widget.dataHomePage2.newAssignments[index].toString(),
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 22,
                        maxLines: 1,
                        style: GoogleFonts.cabin(
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        widget.dataHomePage2.newClasses[index].toString(),
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 15,
                        maxLines: 1,
                        style: GoogleFonts.cabin(
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: AutoSizeText(
                        widget.dataHomePage2.newScores[index].toString(),
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 21,
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[850],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      newGrades = Expanded(
        child: Container(
          width: 350,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.cyan[100],
          ),
          child: AutoSizeText(
            "No New Grades...",
            overflow: TextOverflow.ellipsis,
            minFontSize: 30,
            maxLines: 1,
            style: GoogleFonts.cabin(
              letterSpacing: 1.2,
              color: Colors.grey[800],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 4,
              left: 13,
              right: 13,
              bottom: 13,
            ),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.orange[100],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome,',
                  style: GoogleFonts.asap(
                    textStyle:
                        TextStyle(fontSize: 65.0, color: Colors.grey[850]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                AutoSizeText(
                  widget.dataHomePage2.studentName + '!',
                  style: GoogleFonts.bitter(
                    textStyle: TextStyle(
                        fontSize: 40.0, height: 1.3, color: Colors.grey[800]),
                  ),
                  maxLines: 1,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Text(
                  "Grade: " + widget.dataHomePage2.studentGrade,
                  style: GoogleFonts.ibmPlexSans(
                    textStyle:
                        TextStyle(fontSize: 25.0, color: Colors.grey[800]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Text(
                  "User: " + widget.dataHomePage2.user,
                  style: GoogleFonts.ibmPlexSans(
                    textStyle:
                        TextStyle(fontSize: 25.0, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: 350,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.cyan[100],
            ),
            child: Text(
              "New Added Grades: ",
              style: GoogleFonts.bitter(
                textStyle: TextStyle(fontSize: 25.0, color: Colors.grey[800]),
              ),
            ),
          ),
          Divider(
            indent: 24,
            endIndent: 24,
            thickness: 1.2,
            color: Colors.grey[900],
          ),
          newGrades,
        ],
      ),
    );
  }
}
