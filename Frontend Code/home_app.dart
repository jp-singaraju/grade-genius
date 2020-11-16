import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';

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
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey.withOpacity(.6),
      statusBarColor: Colors.grey.withOpacity(.6),
    ));
    int assignments = widget.dataHomePage2.newAssignments.length;
    if (assignments > 0) {
      newGrades = Expanded(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          width: width / 1.16,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.cyan[100],
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              itemCount: widget.dataHomePage2.newAssignments.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(bottom: 7.5, left: 10, right: 10, top: 3),
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
                          width: 1.6,
                        ),
                        borderRadius: new BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: ListTile(
                        title: AutoSizeText(
                          widget.dataHomePage2.newAssignments[index].toString(),
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 16,
                          maxLines: 1,
                          style: GoogleFonts.cabin(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: AutoSizeText(
                          widget.dataHomePage2.newClasses[index].toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.cabin(
                            color: Colors.grey[700],
                          ),
                        ),
                        trailing: AutoSizeText(
                          widget.dataHomePage2.newScores[index].toString(),
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 16,
                          maxLines: 1,
                          style: GoogleFonts.ubuntu(
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
        ),
      );
    } else {
      newGrades = Expanded(
        child: Container(
          width: width / 1.16,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.cyan[100],
          ),
          child: AutoSizeText(
            "Nothing New...",
            overflow: TextOverflow.ellipsis,
            minFontSize: 25,
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
            width: width / 1.16,
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
                AutoSizeText(
                  'Welcome,',
                  minFontSize: 45,
                  style: GoogleFonts.asap(
                    textStyle: TextStyle(
                      color: Colors.grey[850],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                AutoSizeText(
                  widget.dataHomePage2.studentName + '!',
                  textAlign: TextAlign.center,
                  minFontSize: 24,
                  style: GoogleFonts.bitter(
                    textStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                AutoSizeText(
                  "Grade: " + widget.dataHomePage2.studentGrade,
                  minFontSize: 22.0,
                  style: GoogleFonts.ibmPlexSans(
                    textStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
                AutoSizeText(
                  "User: " + widget.dataHomePage2.user,
                  minFontSize: 22.0,
                  style: GoogleFonts.ibmPlexSans(
                    textStyle: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(13),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: width / 1.16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.cyan[100],
            ),
            child: AutoSizeText(
              "New Added Grades: ",
              minFontSize: 23.0,
              style: GoogleFonts.bitter(
                textStyle: TextStyle(
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          Divider(
            indent: width / 15,
            endIndent: width / 15,
            thickness: 1.2,
            color: Colors.grey[900],
          ),
          newGrades,
        ],
      ),
    );
  }
}
