import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'main.dart';
import 'package:json_table/json_table.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';

class MyExtrasPage extends StatefulWidget {
  final DataInfo dataExtras;
  MyExtrasPage({this.dataExtras});

  @override
  ExtraApp createState() => ExtraApp();
}

class ExtraApp extends State<MyExtrasPage> {
  var client = HttpClient();
  List<Cookie> myCookies = [];
  var iprMap;
  var rcMap;
  var scheduleMap;
  String weightedGPA;
  String unweightedGPA;
  bool showIPR = false;
  bool showSchedule = false;
  bool showRC = false;
  String reportRun = '';
  bool error = false;
  bool unableAccess = false;
  bool isLoading = false;

  // local Android host url = 'http://10.0.2.2:5000/'
  // app url = 'https://gradegenius.org/'
  String host = 'https://gradegenius.org/';

  Future<HttpClientResponse> makeRequest(
      Uri uri, List<Cookie> requestCookies) async {
    var request = await client.getUrl(uri);
    print(uri);
    request.cookies.addAll(requestCookies);
    request.followRedirects = false;
    return await request.close();
  }

  Future mainRequest(urlReceiver) async {
    setState(() {
      myCookies = widget.dataExtras.myCookies;
    });
    var response = await makeRequest(Uri.parse(urlReceiver), myCookies);
    if (response.statusCode == 404 || response.statusCode == 500) {
      setState(() {
        unableAccess = true;
      });
    }
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey.withOpacity(.6),
      statusBarColor: Colors.grey.withOpacity(.6),
    ));

    Future<bool> _willPopCallback() async {
      return false;
    }

    var loading = isLoading
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: width / 1.2,
                      height: height / 3.6,
                      alignment: AlignmentDirectional.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: SizedBox(
                              height: height / 15,
                              width: width / 8,
                              child: SpinKitFadingCircle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25.0),
                            child: Center(
                              child: AutoSizeText(
                                'Loading Info...',
                                minFontSize: 22,
                                style: GoogleFonts.patrickHand(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : new Container();

    var pullError = error
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Stack(
              children: [
                Align(
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.white.withOpacity(.85),
                  ),
                ),
                Align(
                  child: Container(
                    width: width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey[500],
                        width: 2.6,
                      ),
                    ),
                    child: SimpleDialogOption(
                      child: Container(
                        height: height / 3,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'HAC is probably down, this report is currently unavailable in HAC, or Grade Genius could not process this report. Please try again later.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          error = false;
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    var iprInfo = showIPR
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      onPressed: () {
                        setState(() {
                          showIPR = false;
                        });
                      },
                      color: Colors.red[400],
                      child: Container(
                        width: width / 13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  AutoSizeText(
                    "Interim Progress Report (IPR)",
                    minFontSize: 24.0,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.asap(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[100].withOpacity(.98),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey[500],
                        width: 2.6,
                      ),
                    ),
                    child: Column(
                      children: [
                        JsonTable(
                          iprMap,
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                        ),
                        AutoSizeText(
                          reportRun,
                          minFontSize: 17,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.asap(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : new Container();

    var scheduleInfo = showSchedule
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      onPressed: () {
                        setState(() {
                          showSchedule = false;
                        });
                      },
                      color: Colors.red[400],
                      child: Container(
                        width: width / 13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AutoSizeText(
                    "Schedule",
                    textAlign: TextAlign.center,
                    minFontSize: 24.0,
                    style: GoogleFonts.asap(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[100].withOpacity(.98),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey[500],
                        width: 2.6,
                      ),
                    ),
                    child: Column(
                      children: [
                        JsonTable(
                          scheduleMap,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : new Container();

    var rcInfo = showRC
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      onPressed: () {
                        setState(() {
                          showRC = false;
                        });
                      },
                      color: Colors.red[400],
                      child: Container(
                        width: width / 13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AutoSizeText(
                    "Report Card",
                    textAlign: TextAlign.center,
                    minFontSize: 24.0,
                    style: GoogleFonts.asap(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[100].withOpacity(.98),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey[500],
                        width: 2.6,
                      ),
                    ),
                    child: Column(
                      children: [
                        JsonTable(
                          rcMap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : new Container();

    void getGPA() async {
      String gpaList = await mainRequest(host + 'gpa');
      var jsonFile = json.decode(gpaList);
      setState(() {
        unweightedGPA = jsonFile['Unweighted GPA'];
        weightedGPA = jsonFile['Weighted GPA'];
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.amber,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            AutoSizeText(
                              "GPA Calc",
                              minFontSize: 20,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            FaIcon(
                              FontAwesomeIcons.calculator,
                              size: width / 4,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            getGPA();
                            Map myList = {};
                            var gList1 = await mainRequest(
                                (host + 'runcalcinfo?number=1').toString());
                            var gradesList1 = json.decode(gList1);
                            var gList2 = await mainRequest(
                                (host + 'runcalcinfo?number=2').toString());
                            var gradesList2 = json.decode(gList2);
                            var gList3 = await mainRequest(
                                (host + 'runcalcinfo?number=3').toString());
                            var gradesList3 = json.decode(gList3);
                            var gList4 = await mainRequest(
                                (host + 'runcalcinfo?number=4').toString());
                            var gradesList4 = json.decode(gList4);
                            myList.addAll({
                              'Class Name 1': gradesList1["Averages"]
                                  ["Class Name"],
                              'Class Grade 1': gradesList1["Averages"]
                                  ["Class Average"],
                              'Class Name 2': gradesList2["Averages"]
                                  ["Class Name"],
                              'Class Grade 2': gradesList2["Averages"]
                                  ["Class Average"],
                              'Class Name 3': gradesList3["Averages"]
                                  ["Class Name"],
                              'Class Grade 3': gradesList3["Averages"]
                                  ["Class Average"],
                              'Class Name 4': gradesList4["Averages"]
                                  ["Class Name"],
                              'Class Grade 4': gradesList4["Averages"]
                                  ["Class Average"],
                              'Unweighted GPA': unweightedGPA,
                              'Weighted GPA': weightedGPA,
                              'Name': widget.dataExtras.studentName,
                            });
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyGPAPage(
                                  dataGPAPage: myList,
                                ),
                              ),
                            );
                          } on RangeError {
                            error = true;
                          }
                        },
                        highlightColor: Colors.amber,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.amber,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            AutoSizeText(
                              "Schedule",
                              minFontSize: 20,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            FaIcon(
                              FontAwesomeIcons.calendarAlt,
                              size: width / 4,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            var scheduleList =
                                await mainRequest(host + 'schedule');
                            if (unableAccess == false) {
                              setState(
                                () {
                                  scheduleMap = json.decode(scheduleList);
                                  var finalList = [];
                                  for (int index = 0;
                                      index < scheduleMap["Class"].length;
                                      index++) {
                                    finalList.add({
                                      'Course': scheduleMap["Course"][index]
                                          .toString(),
                                      'Class': scheduleMap["Class"][index]
                                          .toString(),
                                      'Period': scheduleMap["Period"][index]
                                          .toString(),
                                      'Days':
                                          scheduleMap["Days"][index].toString(),
                                      'Teacher': scheduleMap["Teacher"][index]
                                          .toString(),
                                      'Room':
                                          scheduleMap["Room"][index].toString(),
                                      'MP': scheduleMap["Marking Period"][index]
                                          .toString(),
                                      'Building': scheduleMap["Building"][index]
                                          .toString(),
                                    });
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  String myVar = json.encode(finalList);
                                  scheduleMap = json.decode(myVar);
                                  showSchedule = true;
                                },
                              );
                            } else {
                              setState(() {
                                unableAccess = false;
                                error = true;
                              });
                            }
                          } on NoSuchMethodError {
                            setState(() {
                              error = true;
                            });
                          } on FormatException {
                            setState(() {
                              error = true;
                            });
                          } on Error {
                            setState(() {
                              error = true;
                            });
                          } on Exception {
                            setState(() {
                              error = true;
                            });
                          }
                        },
                        highlightColor: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.amber,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            AutoSizeText(
                              "IPR",
                              minFontSize: 20,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            FaIcon(
                              FontAwesomeIcons.clipboardList,
                              size: width / 4,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            var iprList = await mainRequest(host + 'ipr');
                            if (unableAccess == false) {
                              setState(
                                () {
                                  iprMap = jsonDecode(iprList);
                                  reportRun = iprMap["Run"];
                                  iprMap = iprMap["Schedule"];
                                  var finalList = [];
                                  for (int index = 0;
                                      index < iprMap["Class"].length;
                                      index++) {
                                    finalList.add({
                                      'Course':
                                          iprMap["Course"][index].toString(),
                                      'Class':
                                          iprMap["Class"][index].toString(),
                                      'Period':
                                          iprMap["Period"][index].toString(),
                                      'Teacher':
                                          iprMap["Teacher"][index].toString(),
                                      'Room': iprMap["Room"][index].toString(),
                                      'Grade':
                                          iprMap["Grade"][index].toString(),
                                    });
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  String myVar = json.encode(finalList);
                                  iprMap = json.decode(myVar);
                                  showIPR = true;
                                },
                              );
                            } else {
                              setState(() {
                                unableAccess = false;
                                error = true;
                              });
                            }
                          } on NoSuchMethodError {
                            setState(() {
                              error = true;
                            });
                          } on FormatException {
                            setState(() {
                              error = true;
                            });
                          } on Error {
                            setState(() {
                              error = true;
                            });
                          } on Exception {
                            setState(() {
                              error = true;
                            });
                          }
                        },
                        highlightColor: Colors.amber,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.amber,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            AutoSizeText(
                              "Report Card",
                              minFontSize: 20,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            FaIcon(
                              FontAwesomeIcons.fileAlt,
                              size: width / 4,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          var rcList = await mainRequest(host + 'reportcard');
                          try {
                            if (unableAccess == false) {
                              setState(() {
                                rcMap = json.decode(rcList);
                                List myKeys = rcMap.keys.toList();
                                var finalList = [];
                                int counter = 0;
                                var myList = [];
                                for (int index = 0;
                                    index < rcMap[myKeys[0]].length;
                                    index++) {
                                  for (int val = 0;
                                      val < myKeys.length;
                                      val++) {
                                    myList.add(rcMap[myKeys[val]]
                                        [(counter + 1).toString()]);
                                  }
                                  counter++;
                                  var myMap = {};
                                  for (int val = 0;
                                      val < myList.length;
                                      val++) {
                                    myMap.addAll({myKeys[val]: myList[val]});
                                  }
                                  finalList.add(myMap);
                                  myList = [];
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                String myVar = json.encode(finalList);
                                rcMap = json.decode(myVar);
                                showRC = true;
                              });
                            } else {
                              setState(() {
                                unableAccess = false;
                                error = true;
                              });
                            }
                          } on NoSuchMethodError {
                            setState(() {
                              error = true;
                            });
                          } on FormatException {
                            setState(() {
                              error = true;
                            });
                          } on Error {
                            setState(() {
                              error = true;
                            });
                          } on Exception {
                            setState(() {
                              error = true;
                            });
                          }
                        },
                        highlightColor: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Align(
            child: loading,
            alignment: Alignment.center,
          ),
          Align(
            child: iprInfo,
            alignment: Alignment.center,
          ),
          Align(
            child: scheduleInfo,
            alignment: Alignment.center,
          ),
          Align(
            child: rcInfo,
            alignment: Alignment.center,
          ),
          Align(
            child: pullError,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}

class MyGPAPage extends StatefulWidget {
  final dataGPAPage;
  MyGPAPage({this.dataGPAPage});

  @override
  GPAPage createState() => GPAPage();
}

class GPAPage extends State<MyGPAPage> {
  final TextEditingController grade1 = TextEditingController();
  String uGPA1 = "";
  String uGPA2 = "";
  String wGPA1 = "";
  String wGPA2 = "";
  String unweightedCummGPA = "";
  String weightedCummGPA = "";
  String unweightedGPA = "0.000";
  String weightedGPA = "0.000";
  bool showGPAPage = false;
  double buttonVal = 1;
  double prevButtonVal = 1;
  var showInfo = false;
  bool showWeights = false;
  int dropdownValue = 1;
  int indexVal = 0;
  List randGPAWeights1 = [];
  List randGPAWeights2 = [];
  List classGrades1 = [];
  List classGrades2 = [];
  bool error = false;
  String ogWeighted1 = "";
  String ogUnweighted1 = "";
  String ogWeighted2 = "";
  String ogUnweighted2 = "";
  int counter1 = 0;
  int counter2 = 0;
  String finalW = "";
  String finalU = "";
  bool isDiffW = false;
  bool isDiffU = false;
  bool displayError = false;

  void initState() {
    super.initState();
    grade1.addListener(() {
      final text = grade1.text.toLowerCase();
      grade1.value = grade1.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey.withOpacity(.6),
      statusBarColor: Colors.grey.withOpacity(.6),
    ));
    List sem1Names = [];
    List sem1Grades = [];
    List sem2Names = [];
    List sem2Grades = [];
    List finalGrades = [];
    List finalNames = [];
    List unweightedList = [];
    List myGpaActual = [];
    List myGpaWeights = [];

    Future<bool> _willPopCallback() async {
      return false;
    }

    try {
      widget.dataGPAPage["Class Name 1"].forEach((element) {
        sem1Names.add(element);
      });
      widget.dataGPAPage["Class Grade 1"].forEach((element) {
        sem1Grades.add(element);
      });
      widget.dataGPAPage["Class Name 2"].forEach((element) {
        sem1Names.add(element);
      });
      widget.dataGPAPage["Class Grade 2"].forEach((element) {
        sem1Grades.add(element);
      });
      widget.dataGPAPage["Class Name 3"].forEach((element) {
        sem2Names.add(element);
      });
      widget.dataGPAPage["Class Grade 3"].forEach((element) {
        sem2Grades.add(element);
      });
      widget.dataGPAPage["Class Name 4"].forEach((element) {
        sem2Names.add(element);
      });
      widget.dataGPAPage["Class Grade 4"].forEach((element) {
        sem2Grades.add(element);
      });

      cummalativeCalcs(var1, var2, myRandNum) {
        List uList = [];
        List myGpaA = [];
        List myGpaW = [];
        List finalG = var1;
        List finalN = var2;

        if (myRandNum == 1) {
          if (randGPAWeights1.length == 0) {
            for (int index = 0; index < finalG.length; index++) {
              if (finalN[index].contains("PAP") == true) {
                myGpaW.add(5.5);
              } else if (finalN[index].contains("AP") == true) {
                myGpaW.add(6.0);
              } else {
                myGpaW.add(5.0);
              }
            }
          } else {
            myGpaW = randGPAWeights1;
            finalG = classGrades1;
          }
          if (classGrades1.length != 0) {
            finalGrades = classGrades1;
            finalG = classGrades1;
          }
        } else if (myRandNum == 2) {
          if (randGPAWeights2.length == 0) {
            for (int index = 0; index < finalG.length; index++) {
              if (finalN[index].contains("PAP") == true) {
                myGpaW.add(5.5);
              } else if (finalN[index].contains("AP") == true) {
                myGpaW.add(6.0);
              } else {
                myGpaW.add(5.0);
              }
            }
          } else {
            myGpaW = randGPAWeights2;
            finalG = classGrades2;
          }
          if (classGrades2.length != 0) {
            finalGrades = classGrades2;
            finalG = classGrades2;
          }
        }
        for (int index = 0; index < myGpaW.length; index++) {
          String grade = finalG[index];
          if (grade != null && grade != "" && grade != "N/A") {
            grade = grade.substring(0, grade.length - 1);
            if (!(double.parse(grade) < 70)) {
              if (double.parse(grade) > 100) {
                grade = "100.00";
              }
              double val = (100 - double.parse(grade)) / 10;
              myGpaA.add((myGpaW[index] - val).toStringAsFixed(3));
            } else {
              myGpaA.add(0.toStringAsFixed(3));
            }
          } else {
            myGpaA.add("N/A");
          }
        }
        int count = 0;
        double finalVar = 0;
        for (int index = 0; index < myGpaA.length; index++) {
          if (myGpaA[index] != "N/A") {
            finalVar += double.parse(myGpaA[index]);
            count++;
          }
        }
        if (count == 0) {
          count = 1;
          finalVar = 0;
        }

        for (int index = 0; index < finalG.length; index++) {
          String grade = finalG[index];
          if (grade != null && grade != "") {
            grade = grade.substring(0, grade.length - 1);
            if (double.parse(grade) >= 94) {
              uList.add(4.0);
            } else if (double.parse(grade) >= 90) {
              uList.add(3.7);
            } else if (double.parse(grade) >= 87) {
              uList.add(3.3);
            } else if (double.parse(grade) >= 84) {
              uList.add(3.0);
            } else if (double.parse(grade) >= 80) {
              uList.add(2.7);
            } else if (double.parse(grade) >= 77) {
              uList.add(2.3);
            } else if (double.parse(grade) >= 74) {
              uList.add(2.0);
            } else if (double.parse(grade) >= 70) {
              uList.add(1.7);
            } else if (double.parse(grade) >= 67) {
              uList.add(1.3);
            } else if (double.parse(grade) >= 64) {
              uList.add(1.0);
            } else if (double.parse(grade) >= 60) {
              uList.add(0.7);
            } else if (double.parse(grade) >= 0) {
              uList.add(0.0);
            }
          } else {
            uList.add("N/A");
          }
        }

        int count1 = 0;
        double finalVar1 = 0;
        for (int index = 0; index < uList.length; index++) {
          if (myGpaA[index] != "N/A") {
            finalVar1 += uList[index];
            count1++;
          }
        }
        if (count1 == 0) {
          count1 = 1;
          finalVar1 = 0;
        }
        final w = (finalVar / count).toStringAsFixed(3);
        final u = (finalVar1 / count1).toStringAsFixed(3);
        return [w, u];
      }

      List sem1 = cummalativeCalcs(sem1Grades, sem1Names, 1);
      wGPA1 = sem1[0];
      uGPA1 = sem1[1];

      List sem2 = cummalativeCalcs(sem2Grades, sem2Names, 2);
      wGPA2 = sem2[0];
      uGPA2 = sem2[1];

      if (widget.dataGPAPage["Weighted GPA"] != "None" &&
          widget.dataGPAPage["Unweighted GPA"] != "None" &&
          widget.dataGPAPage["Weighted GPA"] != null &&
          widget.dataGPAPage["Unweighted GPA"] != null) {
        weightedCummGPA = (double.parse(wGPA1) +
                double.parse(wGPA2) +
                double.parse(widget.dataGPAPage["Weighted GPA"]))
            .toStringAsFixed(3);
        unweightedCummGPA = (double.parse(uGPA1) +
                double.parse(uGPA2) +
                double.parse(widget.dataGPAPage["Unweighted GPA"]))
            .toStringAsFixed(3);
      } else {
        weightedCummGPA =
            (double.parse(wGPA1) + double.parse(wGPA2) + 0).toStringAsFixed(3);
        unweightedCummGPA =
            (double.parse(uGPA1) + double.parse(uGPA2) + 0).toStringAsFixed(3);
      }

      int wCount = 0;
      int uCount = 0;

      if (double.parse(wGPA1) != 0) {
        wCount++;
      }
      if (double.parse(wGPA2) != 0) {
        wCount++;
      }
      if (double.parse(uGPA1) != 0) {
        uCount++;
      }
      if (double.parse(uGPA2) != 0) {
        uCount++;
      }
      if (widget.dataGPAPage["Weighted GPA"] != "None" &&
          widget.dataGPAPage["Weighted GPA"] != null) {
        wCount++;
      }
      if (widget.dataGPAPage["Unweighted GPA"] != "None" &&
          widget.dataGPAPage["Unweighted GPA"] != null) {
        uCount++;
      }

      weightedCummGPA =
          (double.parse(weightedCummGPA) / wCount).toStringAsFixed(3);
      unweightedCummGPA =
          (double.parse(unweightedCummGPA) / uCount).toStringAsFixed(3);

      void myGpaAssigner() {
        if (buttonVal == 1) {
          finalGrades = sem1Grades;
          finalNames = sem1Names;
          if (randGPAWeights1.length == 0) {
            for (int index = 0; index < finalGrades.length; index++) {
              if (finalNames[index].contains("PAP") == true) {
                myGpaWeights.add(5.5);
              } else if (finalNames[index].contains("AP") == true) {
                myGpaWeights.add(6.0);
              } else {
                myGpaWeights.add(5.0);
              }
            }
          } else {
            myGpaWeights = randGPAWeights1;
          }
          if (classGrades1.length != 0) {
            finalGrades = classGrades1;
          }
        } else if (buttonVal == 2) {
          finalGrades = sem2Grades;
          finalNames = sem2Names;
          if (randGPAWeights2.length == 0) {
            for (int index = 0; index < finalGrades.length; index++) {
              if (finalNames[index].contains("PAP") == true) {
                myGpaWeights.add(5.5);
              } else if (finalNames[index].contains("AP") == true) {
                myGpaWeights.add(6.0);
              } else {
                myGpaWeights.add(5.0);
              }
            }
          } else {
            myGpaWeights = randGPAWeights2;
          }
          if (classGrades2.length != 0) {
            finalGrades = classGrades2;
          }
        }
      }

      myGpaAssigner();

      for (int index = 0; index < myGpaWeights.length; index++) {
        String grade = finalGrades[index];
        if (grade != null && grade != "") {
          grade = grade.substring(0, grade.length - 1);
          if (!(double.parse(grade) < 70)) {
            if (double.parse(grade) > 100) {
              grade = "100.00";
            }
            double val = (100 - double.parse(grade)) / 10;
            myGpaActual.add((myGpaWeights[index] - val).toStringAsFixed(3));
          } else {
            myGpaActual.add(0.toStringAsFixed(3));
          }
        } else {
          myGpaActual.add("N/A");
        }
      }
      int count = 0;
      double finalVar = 0;
      for (int index = 0; index < myGpaActual.length; index++) {
        if (myGpaActual[index] != "N/A") {
          finalVar += double.parse(myGpaActual[index]);
          count++;
        }
      }
      if (count == 0) {
        count = 1;
        finalVar = 0;
      }
      weightedGPA = (finalVar / count).toStringAsFixed(3);

      for (int index = 0; index < finalGrades.length; index++) {
        String grade = finalGrades[index];
        if (grade != null && grade != "") {
          grade = grade.substring(0, grade.length - 1);
          if (double.parse(grade) >= 94) {
            unweightedList.add(4.0);
          } else if (double.parse(grade) >= 90) {
            unweightedList.add(3.7);
          } else if (double.parse(grade) >= 87) {
            unweightedList.add(3.3);
          } else if (double.parse(grade) >= 84) {
            unweightedList.add(3.0);
          } else if (double.parse(grade) >= 80) {
            unweightedList.add(2.7);
          } else if (double.parse(grade) >= 77) {
            unweightedList.add(2.3);
          } else if (double.parse(grade) >= 74) {
            unweightedList.add(2.0);
          } else if (double.parse(grade) >= 70) {
            unweightedList.add(1.7);
          } else if (double.parse(grade) >= 67) {
            unweightedList.add(1.3);
          } else if (double.parse(grade) >= 64) {
            unweightedList.add(1.0);
          } else if (double.parse(grade) >= 60) {
            unweightedList.add(0.7);
          } else if (double.parse(grade) >= 0) {
            unweightedList.add(0.0);
          }
        } else {
          unweightedList.add("N/A");
        }
      }

      int count1 = 0;
      double finalVar1 = 0;
      for (int index = 0; index < unweightedList.length; index++) {
        if (myGpaActual[index] != "N/A") {
          finalVar1 += unweightedList[index];
          count1++;
        }
      }
      if (count1 == 0) {
        count1 = 1;
        finalVar1 = 0;
      }
      unweightedGPA = (finalVar1 / count1).toStringAsFixed(3);

      grade1.text = finalGrades[indexVal];

      if (grade1.text.length != 0 && grade1.text != null) {
        grade1.text = finalGrades[indexVal]
            .substring(0, finalGrades[indexVal].length - 1);
      }
      if (buttonVal == 1) {
        if (counter1 == 0) {
          ogWeighted1 = weightedGPA;
          ogUnweighted1 = unweightedGPA;
          counter1++;
        }
      } else if (buttonVal == 2) {
        if (counter2 == 0) {
          ogWeighted2 = weightedGPA;
          ogUnweighted2 = unweightedGPA;
          counter2++;
        }
      }

      differenceMethod() {
        if (buttonVal == 1) {
          finalW = (double.parse(weightedGPA) - double.parse(ogWeighted1))
              .toStringAsFixed(3);
          finalU = (double.parse(unweightedGPA) - double.parse(ogUnweighted1))
              .toStringAsFixed(3);
        } else if (buttonVal == 2) {
          finalW = (double.parse(weightedGPA) - double.parse(ogWeighted2))
              .toStringAsFixed(3);
          finalU = (double.parse(unweightedGPA) - double.parse(ogUnweighted2))
              .toStringAsFixed(3);
        }
      }

      differenceMethod();

      double myRandW = double.parse(finalW);
      double myRandU = double.parse(finalU);

      if (myRandW > 0) {
        finalW = "+" + myRandW.toStringAsFixed(3);
        isDiffW = true;
      } else if (myRandW < 0) {
        isDiffW = true;
      }
      if (myRandU > 0) {
        finalU = "+" + myRandU.toStringAsFixed(3);
        isDiffU = true;
      } else if (myRandU < 0) {
        isDiffU = true;
      }
      if (myRandW == 0) {
        isDiffW = false;
      }
      if (myRandU == 0) {
        isDiffU = false;
      }
    } on RangeError {
      error = true;
    } on FormatException {
      error = true;
    } on Exception {
      error = true;
    } on Error {
      error = true;
    }

    List<Color> colorList = [Colors.amber[400], Colors.amber[400]];

    for (int i = 0; i < colorList.length; i++) {
      if (i == (buttonVal - 1)) {
        colorList[i] = Colors.amber[700];
      }
    }

    unweightedGPAMethod(grade) {
      if (grade != null && grade != "") {
        grade = grade.substring(0, grade.length - 1);
        if (double.parse(grade) >= 94) {
          return 4.0;
        } else if (double.parse(grade) >= 90) {
          return 3.7;
        } else if (double.parse(grade) >= 87) {
          return 3.3;
        } else if (double.parse(grade) >= 84) {
          return 3.0;
        } else if (double.parse(grade) >= 80) {
          return 2.7;
        } else if (double.parse(grade) >= 77) {
          return 2.3;
        } else if (double.parse(grade) >= 74) {
          return 2.0;
        } else if (double.parse(grade) >= 70) {
          return 1.7;
        } else if (double.parse(grade) >= 67) {
          return 1.3;
        } else if (double.parse(grade) >= 64) {
          return 1.0;
        } else if (double.parse(grade) >= 60) {
          return 0.7;
        } else if (double.parse(grade) >= 0) {
          return 0.0;
        }
      } else {
        return "N/A";
      }
    }

    bool _isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.parse(s, (e) => null) != null ||
          int.parse(s, onError: (e) => null) != null;
    }

    var wrongGrade = displayError
        ? new Text(
            'Please enter in a valid grade for the class.\n Enter in a numerical value (0 - 100).',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
            ),
          )
        : new Container();

    var showDiffW = isDiffW
        ? new Container(
            alignment: Alignment.center,
            width: width / 6,
            height: height / 29,
            child: AutoSizeText(
              finalW,
              style: GoogleFonts.aBeeZee(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            decoration: isDiffW
                ? BoxDecoration(
                    color: Colors.purple[300],
                    border: Border.all(
                      color: Colors.purple[600],
                      width: 3.5,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  )
                : BoxDecoration(),
          )
        : new Container();

    var showDiffU = isDiffU
        ? new Container(
            alignment: Alignment.center,
            width: width / 6,
            height: height / 29,
            child: AutoSizeText(
              finalU,
              style: GoogleFonts.aBeeZee(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            decoration: isDiffU
                ? BoxDecoration(
                    color: Colors.purple[300],
                    border: Border.all(
                      color: Colors.purple[600],
                      width: 3.5,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  )
                : BoxDecoration(),
          )
        : new Container();

    var pullError = error
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Stack(
              children: [
                Align(
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.white.withOpacity(.85),
                  ),
                ),
                Align(
                  child: Container(
                    width: width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey[500],
                        width: 2.6,
                      ),
                    ),
                    child: SimpleDialogOption(
                      child: Container(
                        height: height / 3,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Grade Genius is unable to access GPA Calculations. Either you are currently logged out or something is wrong. Please login and/or try again later.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          error = false;
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    var gpaCalc = showGPAPage
        ? new Stack(
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(13),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                            onPressed: () {
                              setState(() {});
                              setState(() {
                                showGPAPage = false;
                              });
                            },
                            color: Colors.red[400],
                            child: Container(
                              width: width / 13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: width / 35),
                          child: FloatingActionButton.extended(
                            heroTag: 1,
                            label: AutoSizeText(
                              'Sem 1',
                              minFontSize: 14,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            backgroundColor: colorList[0],
                            onPressed: () {
                              setState(
                                () {
                                  prevButtonVal = buttonVal;
                                  buttonVal = 1;
                                  if (prevButtonVal != buttonVal) {
                                    indexVal = 0;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(left: width / 30),
                          child: FloatingActionButton.extended(
                            heroTag: 2,
                            label: AutoSizeText(
                              'Sem 2',
                              minFontSize: 14,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            backgroundColor: colorList[1],
                            onPressed: () {
                              setState(
                                () {
                                  prevButtonVal = buttonVal;
                                  buttonVal = 2;
                                  if (prevButtonVal != buttonVal) {
                                    indexVal = 0;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: width / 1.1,
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            "Semester " + buttonVal.toStringAsFixed(0) + " GPA",
                            minFontSize: 27,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                        ),
                        Container(
                          width: width / 1.1,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.amber[200],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        width: width / 3,
                                        height: height / 10,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(10),
                                        child: RichText(
                                          text: TextSpan(
                                            text: weightedGPA.toString(),
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 29,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          color: Colors.amber[700],
                                        ),
                                      ),
                                      showDiffW,
                                    ],
                                  ),
                                  AutoSizeText(
                                    "Weighted",
                                    minFontSize: 18,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(6),
                              ),
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: width / 3,
                                        height: height / 10,
                                        padding: EdgeInsets.all(10),
                                        child: RichText(
                                          text: TextSpan(
                                            text: unweightedGPA.toString(),
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 29,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          color: Colors.amber[700],
                                        ),
                                      ),
                                      showDiffU,
                                    ],
                                  ),
                                  AutoSizeText(
                                    "Unweighted",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Container(
                      width: width / 1.1,
                      alignment: Alignment.center,
                      child: Text(
                        "Click on each class to change the weight and/or grade.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                    ),
                    Divider(
                      indent: width / 27,
                      endIndent: width / 27,
                      thickness: 2.4,
                      color: Colors.grey[900],
                    ),
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          itemCount: finalNames.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  bottom: 2.5, top: 5.0, left: 7.0, right: 7.0),
                              child: InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.amber[200],
                                    border: Border.all(
                                      color: Colors.amber[200],
                                      width: 2.6,
                                    ),
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        indexVal = index;
                                      });
                                      setState(() {
                                        showWeights = true;
                                        if (myGpaWeights[indexVal] == 5.0) {
                                          dropdownValue = 1;
                                        } else if (myGpaWeights[indexVal] ==
                                            5.5) {
                                          dropdownValue = 2;
                                        } else if (myGpaWeights[indexVal] ==
                                            6.0) {
                                          dropdownValue = 3;
                                        }
                                      });
                                    },
                                    child: Container(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.only(
                                            left: 6,
                                            right: 8,
                                            top: 2,
                                            bottom: 3),
                                        title: AutoSizeText(
                                          finalNames[index],
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 17,
                                          maxLines: 1,
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        subtitle: AutoSizeText(
                                          "Weight: " +
                                              myGpaWeights[index].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 14,
                                          maxLines: 1,
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        trailing: Container(
                                          padding: EdgeInsets.all(10),
                                          child: RichText(
                                            text: TextSpan(
                                              text: myGpaActual[index],
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 21,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            color: Colors.amber[700],
                                          ),
                                        ),
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
                  ],
                ),
              ),
            ],
          )
        : new Container();

    var editWeights = showWeights
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70.withOpacity(.7),
              ),
              child: Container(
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  color: Colors.white70,
                ),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.9),
                    border: Border.all(
                      color: Colors.grey[600],
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: height / 1.2,
                  width: width / 1.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: width / 5,
                            alignment: Alignment.topLeft,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              onPressed: () {
                                setState(() {
                                  grade1.text = "";
                                  dropdownValue = 1;
                                  showWeights = false;
                                  displayError = false;
                                });
                              },
                              color: Colors.red[400],
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      AutoSizeText(
                        finalNames[indexVal],
                        textAlign: TextAlign.center,
                        minFontSize: 22,
                        maxLines: 2,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(13),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            "Weightage of Class:   ",
                            minFontSize: 18,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              fontSize: 18,
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.amber[800],
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text("5.0"),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("5.5"),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                child: Text("6.0"),
                                value: 3,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value;
                              });
                              setState(() {
                                double myWeight;
                                if (dropdownValue == 1) {
                                  myWeight = 5.0;
                                } else if (dropdownValue == 2) {
                                  myWeight = 5.5;
                                } else {
                                  myWeight = 6.0;
                                }
                                myGpaWeights[indexVal] = myWeight;
                                if (buttonVal == 1) {
                                  randGPAWeights1 = myGpaWeights;
                                } else if (buttonVal == 2) {
                                  randGPAWeights2 = myGpaWeights;
                                }
                                if (buttonVal == 1) {
                                  setState(() {
                                    classGrades1 = finalGrades;
                                  });
                                } else if (buttonVal == 2) {
                                  setState(() {
                                    classGrades2 = finalGrades;
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      Container(
                        width: width / 1.2,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Grade in Class: ",
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Flexible(
                              child: TextField(
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                controller: grade1,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.amber[800]),
                                  ),
                                  contentPadding: EdgeInsets.all(6),
                                ),
                                style: GoogleFonts.roboto(
                                  color: Colors.grey[800],
                                  fontSize: 17,
                                ),
                                onEditingComplete: () {
                                  setState(() {
                                    displayError = false;
                                  });
                                  if ((_isNumeric(grade1.text) == true &&
                                          (double.parse(grade1.text) >= 0 &&
                                              double.parse(grade1.text) <=
                                                  100)) ||
                                      grade1.text == "") {
                                    if (grade1.text.contains("%") == false &&
                                        grade1.text != "") {
                                      grade1.text += "%";
                                    }
                                    finalGrades[indexVal] = grade1.text;
                                  } else {
                                    setState(() {
                                      displayError = true;
                                    });
                                  }
                                  if (buttonVal == 1) {
                                    setState(() {
                                      classGrades1 = finalGrades;
                                    });
                                  } else if (buttonVal == 2) {
                                    setState(() {
                                      classGrades2 = finalGrades;
                                    });
                                  }
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(7),
                            ),
                            AutoSizeText(
                              '%',
                              minFontSize: 18,
                              style: GoogleFonts.roboto(
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(7),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Weighted GPA: ",
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: myGpaActual[indexVal],
                              style: GoogleFonts.roboto(
                                color: Colors.grey[800],
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(7),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Unweighted GPA: ",
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: unweightedGPAMethod(finalGrades[indexVal])
                                  .toString(),
                              style: GoogleFonts.roboto(
                                color: Colors.grey[800],
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(7),
                      ),
                      wrongGrade,
                      Padding(
                        padding: EdgeInsets.all(7),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () async {
                          if ((_isNumeric(grade1.text) == true &&
                                  (double.parse(grade1.text) >= 0 &&
                                      double.parse(grade1.text) <= 100)) ||
                              grade1.text == "") {
                            if ((_isNumeric(grade1.text) == true &&
                                    (double.parse(grade1.text) >= 0 &&
                                        double.parse(grade1.text) <= 100)) ||
                                grade1.text == "") {
                              if (grade1.text.contains("%") == false &&
                                  grade1.text != "") {
                                grade1.text += "%";
                              }
                              finalGrades[indexVal] = grade1.text;
                            } else {
                              setState(() {
                                displayError = true;
                              });
                            }
                            if (buttonVal == 1) {
                              setState(() {
                                classGrades1 = finalGrades;
                              });
                            } else if (buttonVal == 2) {
                              setState(() {
                                classGrades2 = finalGrades;
                              });
                            }
                            setState(() {
                              displayError = false;
                              showWeights = false;
                            });
                          }
                        },
                        color: Colors.green,
                        child: Container(
                          width: width / 1.9,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              AutoSizeText(
                                'Continue',
                                minFontSize: 18,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : new Container();

    var showExtraInfo = showInfo
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Stack(
              children: [
                Align(
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.white.withOpacity(.85),
                  ),
                ),
                Align(
                  child: Container(
                    width: width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey[500],
                        width: 2.6,
                      ),
                    ),
                    child: SimpleDialogOption(
                      child: Container(
                        height: height / 1.4,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'GPA Calculations: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        'GPA is calculated only for students who take high school classes. However, Grade Genius allows all students to calculate their GPA. Please note that this is not a final or accurate GPA; it is just a prediction.',
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: '\n',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'GPA Weightage: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        'Below is the weightage of high school classes in accordance with FISD GPA Policies. The weighted GPA (out of 6.0) is based on the 2023 and beyond GPA Calculations; however, Grade Genius may provide previous GPA Calulcations also. The unweighted GPA (all classes out of 4.0) is based on CollegeBoard GPA standards.',
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '\n2023 and beyond Weighted GPA:\n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: '• AP Classes = 6.0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n• Pre-AP Classes = 5.5',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n• On-Level Classes = 5.0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showInfo = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 11, bottom: 5, left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.red[400],
                          child: Container(
                            width: width / 11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          child: IconButton(
                            tooltip: 'Extra Info',
                            onPressed: () {
                              setState(() {
                                showInfo = true;
                              });
                            },
                            icon: Icon(
                              Icons.info_outline,
                              size: width / 11,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    "Predict Your GPA",
                    minFontSize: 25,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                ),
                Container(
                  width: width / 1.1,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    "Cummulative GPA:",
                    minFontSize: 22,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width / 1.1,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    "This Year + Previous Years",
                    minFontSize: 16,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                ),
                Container(
                  width: width / 1.1,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.amber[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: RichText(
                              text: TextSpan(
                                text: weightedCummGPA,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '\n/6.000',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.amber[700],
                            ),
                          ),
                          AutoSizeText(
                            "Weighted",
                            minFontSize: 19,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: RichText(
                              text: TextSpan(
                                text: unweightedCummGPA,
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '\n/4.000',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.amber[700],
                            ),
                          ),
                          AutoSizeText(
                            "Unweighted",
                            minFontSize: 19,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(7),
                ),
                Container(
                  width: width / 1.1,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    "GPA in HAC:",
                    minFontSize: 22,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width / 1.1,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    "From Transcript",
                    minFontSize: 16,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                ),
                Container(
                  width: width / 1.1,
                  padding: EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.amber[200],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              "Weighted GPA:",
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: RichText(
                                text: TextSpan(
                                  text: widget.dataGPAPage["Weighted GPA"],
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.amber[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        indent: width / 35,
                        endIndent: width / 35,
                        thickness: 2.4,
                        color: Colors.grey[900],
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              "Unweighted GPA:",
                              minFontSize: 19,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: RichText(
                                text: TextSpan(
                                  text: widget.dataGPAPage["Unweighted GPA"],
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.amber[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(7),
                ),
                AutoSizeText(
                  "Changes are only temporary and will be reverted to original once this page is closed.",
                  minFontSize: 13,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                InkWell(
                  child: Container(
                    width: width / 1.1,
                    height: height / 15,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.amber[200],
                    ),
                    child: AutoSizeText(
                      "Click to View More",
                      minFontSize: 19,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      showGPAPage = true;
                    });
                  },
                ),
              ],
            ),
            Align(
              child: showExtraInfo,
              alignment: Alignment.center,
            ),
            Align(
              child: gpaCalc,
              alignment: Alignment.center,
            ),
            Align(
              child: editWeights,
              alignment: Alignment.center,
            ),
            Align(
              child: pullError,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
