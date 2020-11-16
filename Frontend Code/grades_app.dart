import 'package:flutter/material.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';

class MyGradePage extends StatefulWidget {
  final DataInfo dataGrades;
  MyGradePage({this.dataGrades});

  @override
  GradePage createState() => GradePage();
}

class GradePage extends State<MyGradePage> {
  Future<bool> _willPopCallback() async {
    return false;
  }

  // local Android host url = 'http://10.0.2.2:5000/'
  // app url = 'https://gradegenius.org/'
  String host = 'https://gradegenius.org/';
  var client = HttpClient();
  var gradesList;
  bool _load = false;
  bool error = false;
  var sepGrade;
  var isError;

  Future<HttpClientResponse> makeRequest(
      Uri uri, List<Cookie> requestCookies) async {
    var request = await client.getUrl(uri);
    print(uri);
    request.cookies.addAll(requestCookies);
    request.followRedirects = false;
    return await request.close();
  }

  Future mainInfo(reportUrl) async {
    var response = await makeRequest(
      Uri.parse(reportUrl),
      widget.dataGrades.myCookies,
    );

    if (response.statusCode == 404) {
      setState(() {
        error = true;
      });
    } else {
      setState(
        () {
          error = false;
          _load = true;
        },
      );

      Uri location = Uri.parse(response.headers[HttpHeaders.locationHeader][0]);
      response = await makeRequest(location, response.cookies);
      final completer = Completer<String>();
      final contents = StringBuffer();
      response.transform(utf8.decoder).listen((data) {
        contents.write(data);
      }, onDone: () => completer.complete(contents.toString()));
      setState(
        () {
          _load = false;
        },
      );
      return await completer.future;
    }
  }

  getColor(grade) {
    var mainGrade;
    if (grade == '') {
      return Colors.white;
    }
    mainGrade = grade.substring(0, (grade.length - 1));
    mainGrade = double.parse(mainGrade);
    if (mainGrade >= 97.5) {
      return Colors.greenAccent[700];
    } else if (mainGrade >= 90 && mainGrade < 97.5) {
      return Colors.lightGreenAccent[700];
    } else if (mainGrade >= 80 && mainGrade < 90) {
      return Colors.blue;
    } else if (mainGrade >= 75 && mainGrade < 80) {
      return Colors.amber;
    } else if (mainGrade >= 70 && mainGrade < 75) {
      return Colors.orange[700];
    } else if (0 < mainGrade && mainGrade < 70) {
      return Colors.red[800];
    } else {
      return Colors.grey[600];
    }
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
    final classNames = widget.dataGrades.classAverages['Class Name'];
    final classGrades = widget.dataGrades.classAverages['Class Average'];
    String studentGrade = widget.dataGrades.studentGrade;
    var reportVal = widget.dataGrades.reportRun;
    int reportRun = int.parse(reportVal);
    var color;
    bool errorMsg = false;
    List<Color> colorList = [
      Colors.red[50],
      Colors.red[50],
      Colors.red[50],
      Colors.red[50]
    ];

    for (int i = 0; i < colorList.length; i++) {
      if (i == (reportRun - 1)) {
        colorList[i] = Colors.redAccent[100];
      }
    }

    if (classNames.length == 0) {
      errorMsg = true;
    }

    var noData = errorMsg
        ? new Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: width / 13, left: 17, right: 17),
            child: AutoSizeText(
              "Either the session is currently inactive or the grades are blank in HAC.\n\nPlease logout and try again.",
              minFontSize: 19,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : new Container();

    isError = error
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
                        height: height / 2,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Grade Genius could not open the selected Marking Period data. Either the HAC servers are down or the Marking Period has not been updated yet. Please try again later.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          error = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    var loadingIndicator = _load
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
                                'Loading Grades...',
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

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.red[900],
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 10),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width,
                        height: height / 13,
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.all(
                            Radius.circular(23),
                          ),
                          border: Border.all(
                            color: Colors.red[400],
                            width: 1.4,
                          ),
                        ),
                        child: AutoSizeText(
                          'Grades',
                          minFontSize: 30,
                          style: GoogleFonts.signikaNegative(
                            letterSpacing: 0.9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Divider(
                        indent: width / 27,
                        endIndent: width / 27,
                        thickness: 2.8,
                        color: Colors.white70,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(1),
                              child: FloatingActionButton.extended(
                                heroTag: null,
                                label: AutoSizeText(
                                  'MP1',
                                  minFontSize: 9,
                                  style: GoogleFonts.signikaNegative(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: colorList[0],
                                onPressed: () async {
                                  gradesList = await mainInfo(
                                      (host + 'run?number=1').toString());
                                  var currMap;
                                  var reportV;
                                  setState(
                                    () {
                                      if (error != true) {
                                        currMap = json.decode(gradesList);
                                        Map averagesMap = currMap['Averages'];
                                        Map assignmentsMap = currMap['Grades'];
                                        reportV = currMap['Report Run'];
                                        widget.dataGrades.dateList =
                                            currMap["Date List"];
                                        widget.dataGrades.classAverages =
                                            averagesMap;
                                        widget.dataGrades.classAssignments =
                                            assignmentsMap;
                                        widget.dataGrades.reportRun = reportV;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(1),
                              child: FloatingActionButton.extended(
                                heroTag: null,
                                label: AutoSizeText(
                                  'MP2',
                                  minFontSize: 9,
                                  style: GoogleFonts.signikaNegative(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: colorList[1],
                                onPressed: () async {
                                  gradesList = await mainInfo(
                                      (host + 'run?number=2').toString());
                                  var currMap;
                                  var reportV;
                                  setState(
                                    () {
                                      if (error != true) {
                                        currMap = json.decode(gradesList);
                                        Map averagesMap = currMap['Averages'];
                                        Map assignmentsMap = currMap['Grades'];
                                        reportV = currMap['Report Run'];
                                        widget.dataGrades.dateList =
                                            currMap["Date List"];
                                        widget.dataGrades.classAverages =
                                            averagesMap;
                                        widget.dataGrades.classAssignments =
                                            assignmentsMap;
                                        widget.dataGrades.reportRun = reportV;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(1),
                              child: FloatingActionButton.extended(
                                heroTag: null,
                                label: AutoSizeText(
                                  'MP3',
                                  minFontSize: 9,
                                  style: GoogleFonts.signikaNegative(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: colorList[2],
                                onPressed: () async {
                                  gradesList = await mainInfo(
                                      (host + 'run?number=3').toString());
                                  var currMap;
                                  var reportV;
                                  setState(
                                    () {
                                      if (error != true) {
                                        currMap = json.decode(gradesList);
                                        Map averagesMap = currMap['Averages'];
                                        Map assignmentsMap = currMap['Grades'];
                                        reportV = currMap['Report Run'];
                                        widget.dataGrades.dateList =
                                            currMap["Date List"];
                                        widget.dataGrades.classAverages =
                                            averagesMap;
                                        widget.dataGrades.classAssignments =
                                            assignmentsMap;
                                        widget.dataGrades.reportRun = reportV;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(1),
                              child: FloatingActionButton.extended(
                                heroTag: null,
                                label: AutoSizeText(
                                  'MP4',
                                  minFontSize: 9,
                                  style: GoogleFonts.signikaNegative(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: colorList[3],
                                onPressed: () async {
                                  gradesList = await mainInfo(
                                      (host + 'run?number=4').toString());
                                  var currMap;
                                  var reportV;
                                  setState(
                                    () {
                                      if (error != true) {
                                        currMap = json.decode(gradesList);
                                        Map averagesMap = currMap['Averages'];
                                        Map assignmentsMap = currMap['Grades'];
                                        reportV = currMap['Report Run'];
                                        widget.dataGrades.dateList =
                                            currMap["Date List"];
                                        widget.dataGrades.classAverages =
                                            averagesMap;
                                        widget.dataGrades.classAssignments =
                                            assignmentsMap;
                                        widget.dataGrades.reportRun = reportV;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(bottom: 1),
                ),
                noData,
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemExtent: height / 8.5,
                      itemCount: classNames.length,
                      itemBuilder: (context, index) {
                        var text;
                        var colorText = Colors.white;
                        var fontSz = 17.0;
                        text = classGrades[index];
                        var gradeLength = widget.dataGrades.classAssignments[
                            'Class ' + (index + 1).toString()]["Assignments"];
                        if (classGrades[index] == '' &&
                            gradeLength.length == 0) {
                          text = 'N/A ';
                          colorText = Colors.black;
                          fontSz = 17.0;
                        } else if (classGrades[index] == '' &&
                            gradeLength.length != 0) {
                          text = '  ';
                          colorText = Colors.black;
                          fontSz = 17.0;
                        }
                        color = getColor(classGrades[index]);
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: 6.0, top: 6.0, left: 3.0, right: 3.0),
                          child: InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey[700],
                                  width: 2.6,
                                ),
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: ListTile(
                                  title: Container(
                                    width: width / 1.3,
                                    child: AutoSizeText(
                                      classNames[index],
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 16,
                                      maxLines: 1,
                                      style: GoogleFonts.signikaNegative(
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[850],
                                      ),
                                    ),
                                  ),
                                  trailing: Container(
                                    width: width / 4.4,
                                    height: height / 15,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.83),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        AutoSizeText(
                                          text.substring(0, text.length - 1),
                                          maxLines: 1,
                                          minFontSize: 17,
                                          style: GoogleFonts.rambla(
                                            letterSpacing: 1.1,
                                            fontSize: fontSz,
                                            fontWeight: FontWeight.bold,
                                            color: colorText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    var indexInfo = widget
                                                .dataGrades.classAssignments[
                                            'Class ' + (index + 1).toString()]
                                        ["Assignments"];
                                    Map infoDict = {};
                                    if (indexInfo.length != 0) {
                                      Map classInfo = {
                                        'Name': classNames[index],
                                        'Grade': classGrades[index]
                                      };
                                      infoDict.addAll(widget
                                              .dataGrades.classAssignments[
                                          'Class ' + (index + 1).toString()]);
                                      infoDict.addAll(classInfo);
                                      infoDict
                                          .addAll({"Std Grade": studentGrade});
                                      infoDict.addAll({
                                        "Date List":
                                            widget.dataGrades.dateList[index]
                                      });
                                      infoDict.addAll({
                                        "New Assignments":
                                            widget.dataGrades.newAssignments
                                      });
                                      infoDict.addAll({
                                        "New Scores":
                                            widget.dataGrades.newScores
                                      });
                                      infoDict.addAll({
                                        "New Classes":
                                            widget.dataGrades.newClasses
                                      });
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          curve: Curves.linear,
                                          type: PageTransitionType.downToUp,
                                          child: MyAssignmentsPage(
                                            dataGradePage: infoDict,
                                          ),
                                        ),
                                      );
                                    }
                                  },
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
            Align(
              child: isError,
              alignment: FractionalOffset.center,
            ),
            Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MyAssignmentsPage extends StatefulWidget {
  final dataGradePage;
  MyAssignmentsPage({this.dataGradePage});

  @override
  AssignmentsPage createState() => AssignmentsPage();
}

class AssignmentsPage extends State<MyAssignmentsPage> {
  var myClassList;
  var cannotEdit;
  var newAddition;
  var replacement;
  var past6;
  var newGrades;
  var countAdded = 0;
  bool addNew = false;
  String gradeType;
  bool editG = false;
  int changeNum;
  int radioVal = -1;
  var weight = TextEditingController(text: '1.00');
  var grade = TextEditingController();
  String gradeError;
  String weightError;
  bool categoryNA = false;
  bool showInfo = false;
  bool editError = false;
  bool additionError = false;
  bool myBoolChanged = false;
  var majorMinorAvg;
  bool showAvg = false;
  bool editMyGrade = false;

  @override
  void initState() {
    myClassList = json.decode(json.encode(widget.dataGradePage));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey.withOpacity(.6),
      statusBarColor: Colors.grey.withOpacity(.6),
    ));
    String gradeStr = grade.text;
    String weightStr = weight.text;
    var classAssignments = myClassList['Assignments'];
    var assignmentsGrades = myClassList['Score'];
    var assignmentsCategory = myClassList['Category'];
    var assignmentsDueDate = myClassList['Due Date'];
    var assignmentsWeight = myClassList['Weight'];
    var assignmentsWeightScore = myClassList['Weighted Score'];
    var assignmentsTotalPoints = myClassList['Weighted Total Points'];
    var assignmentsPercent = myClassList['Percentage'];
    var className = myClassList['Name'];
    var classGrade = myClassList['Grade'];
    var firstGrade = widget.dataGradePage['Grade'];
    var date = myClassList['Date List'];
    List rand = date.split(" ");
    date = rand[rand.length - 1];
    date = date.substring(0, date.length - 1);
    var countGrades = assignmentsWeightScore.length;
    String studentGrade = widget.dataGradePage['Std Grade'];
    String printText;
    double totalAverage = 0;
    double totalPoints = 0,
        majorPoints = 0,
        minorPoints = 0,
        otherPoints = 0,
        majorTotal = 0,
        minorTotal = 0,
        otherTotal = 0;
    bool showDiff = false;
    int avgMajorCount = 0;
    int avgMinorCount = 0;
    int totalNum = 0;

    if (firstGrade == '') {
      firstGrade = '0.00%';
    }

    firstGrade = firstGrade.substring(0, (firstGrade.length - 1));

    for (int i = 0; i < assignmentsCategory.length; i++) {
      if (assignmentsCategory[i] == 'Minor Grades') {
        avgMinorCount++;
      } else if (assignmentsCategory[i] == 'Major Grades') {
        avgMajorCount++;
      }
    }

    for (int i = 0; i < assignmentsWeightScore.length; i++) {
      double points;
      if (assignmentsWeightScore[i] != '0' && assignmentsWeightScore[i] != '') {
        points = double.parse(assignmentsWeightScore[i]);
        totalPoints = double.parse(assignmentsTotalPoints[i]);
      } else {
        points = 0;
        totalPoints = 0;
      }
      if (points != 0) {
        String category = assignmentsCategory[i];
        if (category == 'Minor Grades') {
          minorPoints += points;
          minorTotal += totalPoints;
        } else if (category == 'Major Grades') {
          majorPoints += points;
          majorTotal += totalPoints;
        } else if (category == 'Non-graded') {
        } else {
          otherPoints += points;
          otherTotal += totalPoints;
        }
      }
    }

    if (minorTotal == 0) {
      minorPoints = 0;
      minorTotal = 1;
    }
    if (majorTotal == 0) {
      majorPoints = 0;
      majorTotal = 1;
    }
    if (otherTotal == 0) {
      otherPoints = 0;
      otherTotal = 1;
    }

    var minorCount = 0;
    var majorCount = 0;
    var otherCount = 0;
    var extraNum = 0;
    var ungradedCount = 0;

    for (int i = 0; i < assignmentsCategory.length; i++) {
      if (assignmentsCategory[i] == 'Minor Grades' &&
          assignmentsGrades[i] != '') {
        minorCount += 1;
      } else if (assignmentsCategory[i] == 'Major Grades' &&
          assignmentsGrades[i] != '') {
        majorCount += 1;
      } else if ((assignmentsCategory[i] == 'Elementary Grades' ||
              assignmentsCategory[i] == 'Other') &&
          assignmentsGrades[i] != '') {
        otherCount += 1;
      } else if (assignmentsCategory[i] == 'Non-Graded') {
        ungradedCount += 1;
      }
    }

    if (minorCount != 0) {
      minorCount = 1;
    } else {
      minorCount = 0;
    }
    if (majorCount != 0) {
      majorCount = 1;
    } else {
      majorCount = 0;
    }
    if (otherCount != 0) {
      otherCount = 1;
    } else {
      otherCount = 0;
    }
    if (ungradedCount != 0) {
      ungradedCount = 1;
    } else {
      ungradedCount = 0;
    }

    if (minorPoints / minorTotal == 0 &&
        majorPoints / majorTotal == 0 &&
        otherPoints / otherTotal == 0) {
      extraNum = 1;
    }

    totalAverage = ((((minorPoints / minorTotal) * .40) +
                ((majorPoints / majorTotal) * .60) +
                ((otherPoints / otherTotal) * 1.00)) /
            ((minorCount * .40) +
                (majorCount * .60) +
                (otherCount * 1.00) +
                extraNum)) *
        100;
    String extra = totalAverage.toStringAsFixed(2);
    totalAverage = double.parse(extra);

    if (!myBoolChanged) {
      totalAverage = double.parse(firstGrade);
      printText = '';
    } else {
      if (totalAverage == double.parse(firstGrade)) {
        printText = '';
      } else if (totalAverage > double.parse(firstGrade)) {
        printText = '+' +
            ((double.parse(firstGrade) - totalAverage)
                .abs()
                .toStringAsFixed(2)) +
            '%';
        showDiff = true;
      } else if (totalAverage < double.parse(firstGrade)) {
        printText = '-' +
            ((double.parse(firstGrade) - totalAverage)
                .abs()
                .toStringAsFixed(2)) +
            '%';
        showDiff = true;
      }
    }

    Future<bool> _willPopCallback() async {
      return false;
    }

    void _radioValChange(int value) {
      setState(() {
        radioVal = value;
        switch (radioVal) {
          case 0:
            radioVal = 0;
            gradeType = 'Minor Grades';
            break;
          case 1:
            radioVal = 1;
            gradeType = 'Major Grades';
            break;
          case 2:
            radioVal = 2;
            gradeType = 'Other';
            break;
        }
      });
    }

    if (studentGrade == '06' ||
        studentGrade == '07' ||
        studentGrade == '08' ||
        studentGrade == '09' ||
        studentGrade == '10' ||
        studentGrade == '11' ||
        studentGrade == '12') {
      replacement = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 0,
            groupValue: radioVal,
            onChanged: _radioValChange,
          ),
          AutoSizeText(
            'Minor',
            style: TextStyle(
              fontSize: 18.0,
              height: 1.2,
              color: Colors.black,
            ),
          ),
          Radio(
            value: 1,
            groupValue: radioVal,
            onChanged: _radioValChange,
          ),
          AutoSizeText(
            'Major',
            style: TextStyle(
              fontSize: 17.5,
              height: 1.2,
              color: Colors.black,
            ),
          ),
        ],
      );
    } else {
      replacement = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 2,
            groupValue: radioVal,
            onChanged: _radioValChange,
          ),
          AutoSizeText(
            'Other',
            style: TextStyle(
              fontSize: 18.0,
              height: 1.2,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    void _changeGrade() {
      if (editG == false) {
        myBoolChanged = true;
        classAssignments =
            classAssignments.add('New Assignment ' + countAdded.toString());
        assignmentsGrades =
            assignmentsGrades.add(double.parse(gradeStr).toStringAsFixed(2));
        assignmentsCategory = assignmentsCategory.add(gradeType);
        assignmentsDueDate = assignmentsDueDate.add('N/A');
        assignmentsWeight =
            assignmentsWeight.add(double.parse(weightStr).toStringAsFixed(2));
        assignmentsWeightScore = assignmentsWeightScore.add(
            (((double.parse(weightStr) * 100)) * (double.parse(gradeStr)) / 100)
                .toStringAsFixed(2));
        assignmentsTotalPoints = assignmentsTotalPoints
            .add((double.parse(weightStr) * 100).toStringAsFixed(2));
        assignmentsPercent = assignmentsPercent
            .add(double.parse(gradeStr).toStringAsFixed(3) + '%');
      } else {
        myBoolChanged = true;
        assignmentsGrades[changeNum] =
            double.parse(gradeStr).toStringAsFixed(2);
        assignmentsCategory[changeNum] = gradeType;
        assignmentsWeight[changeNum] =
            double.parse(weightStr).toStringAsFixed(2);
        assignmentsWeightScore[changeNum] =
            (((double.parse(weightStr) * 100)) * (double.parse(gradeStr)) / 100)
                .toStringAsFixed(2);
        assignmentsTotalPoints[changeNum] =
            (double.parse(weightStr) * 100).toStringAsFixed(2);
        assignmentsPercent[changeNum] =
            double.parse(gradeStr).toStringAsFixed(3) + '%';
      }
    }

    bool _isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.parse(s, (e) => null) != null ||
          int.parse(s, onError: (e) => null) != null;
    }

    void _checkEditError(int index) {
      if (((assignmentsGrades[index] == '' ||
              assignmentsGrades[index] == null ||
              _isNumeric(assignmentsGrades[index]) == false) &&
          (_isNumeric(assignmentsTotalPoints[index]) == false))) {
        setState(() {
          editError = true;
        });
      }
      if (_isNumeric(assignmentsGrades[index]) == false &&
          assignmentsGrades[index] != '') {
        setState(() {
          editError = true;
        });
      }
      if (assignmentsCategory[index] == 'Non-graded') {
        setState(() {
          editError = true;
        });
      }
    }

    var radioNA = categoryNA
        ? new Container(
            child: Text(
              'Please select a category',
              style: TextStyle(
                fontSize: 13,
                color: Colors.red[600],
              ),
            ),
          )
        : new Container();

    cannotEdit = editError
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
                        height: height / 2,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'You cannot edit this assignment\'s info right now. It is either weighted null or has a letter grade (CNS, CWS, T, L, etc.). Also if it is an Non-Graded assignment, it cannot be edited because they are weighted 0%.\n\nPlease try again later if the assignment is changed.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          editError = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    past6 = additionError
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
                        height: height / 5,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'You cannot add more than 6 new grades. Please close the class page and reopen it to enter more new grades.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          additionError = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
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
                    decoration: BoxDecoration(),
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
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    color: Colors.cyan[200].withOpacity(.9),
                                  ),
                                  AutoSizeText(
                                    '   Minor Grades',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    color:
                                        Colors.greenAccent[700].withOpacity(.5),
                                  ),
                                  AutoSizeText(
                                    '   Major Grades',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    color: Colors.deepPurple[200],
                                  ),
                                  AutoSizeText(
                                    '   Other/Non-Graded',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: '\n',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Assignment Weight: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'The weight of the assignment which will be used to calculate the grade (usually from 0.0 to 1.0).',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: '\n',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Assignment Category: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          'How much is the assignment worth (what scale)? ',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '• Major Grades = 60%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n• Minor Grades = 40%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n• Non-Graded = 0%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n• Other Grades ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '(Elementary Grades) ',
                                    ),
                                    TextSpan(
                                      text: '= 100%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
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
                ),
              ],
            ),
          )
        : new Container();

    newAddition = addNew
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.95),
                        border: Border.all(
                          color: Colors.grey[600],
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: width / 1.05,
                      height: height / 1.09,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                height: height / 14,
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.5),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (editMyGrade == false) {
                                          countAdded--;
                                        }
                                        editMyGrade = false;
                                        weightError = null;
                                        gradeError = null;
                                        categoryNA = false;
                                        addNew = false;
                                        editG = false;
                                        radioVal = -1;
                                        grade.clear();
                                        weight.text = '1.00';
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AutoSizeText(
                            'Add/Edit A Grade: ',
                            minFontSize: 23,
                            style: GoogleFonts.cabin(
                              decoration: TextDecoration.underline,
                              textStyle: TextStyle(
                                height: 1.5,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(
                                'Assignment Weight (0.0 to 1.0):',
                                minFontSize: 16,
                                style: GoogleFonts.oxygen(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                controller: weight,
                                decoration: InputDecoration(
                                  errorText: this.weightError,
                                ),
                                style: GoogleFonts.notoSans(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(
                                'Grade Percentage (0.0 to 150.0): ',
                                minFontSize: 16,
                                style: GoogleFonts.oxygen(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      autofocus: true,
                                      textAlign: TextAlign.center,
                                      controller: grade,
                                      decoration: InputDecoration(
                                        errorText: this.gradeError,
                                      ),
                                      style: GoogleFonts.notoSans(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' %',
                                    style: GoogleFonts.oxygen(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.6,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                          ),
                          AutoSizeText(
                            'Category of Assignment: ',
                            minFontSize: 16,
                            style: GoogleFonts.oxygen(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          replacement,
                          radioNA,
                          Padding(
                            padding: EdgeInsets.all(13),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                              setState(() {
                                gradeError = null;
                                weightError = null;
                              });
                              if (radioVal != 0 &&
                                  radioVal != 1 &&
                                  radioVal != 2) {
                                setState(() {
                                  categoryNA = true;
                                });
                              } else if (radioVal == 0 ||
                                  radioVal == 1 ||
                                  radioVal == 2) {
                                setState(() {
                                  categoryNA = false;
                                });
                              }
                              if (_isNumeric(grade.text) == false ||
                                  _isNumeric(weight.text) == false ||
                                  grade.text == null ||
                                  weight.text == null ||
                                  grade.text == '' ||
                                  weight.text == '' ||
                                  (double.parse(grade.text) < 0 ||
                                      double.parse(grade.text) > 150) ||
                                  (double.parse(weight.text) < 0 ||
                                      double.parse(weight.text) > 1.5)) {
                                if (grade.text == null ||
                                    _isNumeric(grade.text) == false ||
                                    grade.text == '') {
                                  setState(() {
                                    gradeError =
                                        'Please enter a valid number (0 to 150)';
                                  });
                                } else if (_isNumeric(grade.text) != false &&
                                    (double.parse(grade.text) < 0 ||
                                        double.parse(grade.text) > 150)) {
                                  setState(() {
                                    gradeError =
                                        'Please enter a valid number (0 to 150)';
                                  });
                                }
                                if (weight.text == null ||
                                    _isNumeric(weight.text) == false ||
                                    weight.text == '') {
                                  setState(() {
                                    weightError =
                                        'Please enter a valid number (0 to 1.5)';
                                  });
                                } else if (_isNumeric(weight.text) != false &&
                                    (double.parse(weight.text) < 0 ||
                                        double.parse(weight.text) > 1.5)) {
                                  setState(() {
                                    weightError =
                                        'Please enter a valid number (0 to 1.5)';
                                  });
                                }
                              } else {
                                setState(() {
                                  gradeStr = grade.text;
                                  weightStr = weight.text;
                                });
                              }
                              if (radioVal != -1 &&
                                  weightError == null &&
                                  gradeError == null) {
                                _changeGrade();
                                setState(() {
                                  editMyGrade = false;
                                  categoryNA = false;
                                  addNew = false;
                                  editG = false;
                                  radioVal = -1;
                                  grade.clear();
                                  weight.text = '1.00';
                                });
                              }
                            },
                            color: Colors.green,
                            child: Container(
                              width: width / 2,
                              padding: EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  AutoSizeText(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 18,
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
                ],
              ),
            ),
          )
        : new Container();

    _tileColor(String category) {
      if (category == 'Minor Grades') {
        return Colors.cyan[200];
      } else if (category == 'Major Grades') {
        return Colors.greenAccent[400].withOpacity(.7);
      } else {
        return Colors.deepPurple[200];
      }
    }

    _assignmentGradeC(grade, index) {
      var mainGrade;
      if ((assignmentsCategory[index] != "Major Grades" &&
              assignmentsCategory[index] != "Minor Grades" &&
              assignmentsCategory[index] != "Elementary Grades") ||
          _isNumeric(grade) == false ||
          (double.parse(assignmentsTotalPoints[index]) < 100) &&
              double.parse(grade.substring(0, (grade.length - 1))) >= 0 &&
              double.parse(grade.substring(0, (grade.length - 1))) <= 100) {
        return Colors.grey[600];
      }
      mainGrade = grade.substring(0, (grade.length - 1));
      mainGrade = double.parse(mainGrade);
      if (mainGrade >= 97.5) {
        return Colors.greenAccent[700];
      } else if (mainGrade >= 90 && mainGrade < 97.5) {
        return Colors.lightGreenAccent[700];
      } else if (mainGrade >= 80 && mainGrade < 90) {
        return Colors.blue;
      } else if (mainGrade >= 75 && mainGrade < 80) {
        return Colors.amber;
      } else if (mainGrade >= 70 && mainGrade < 75) {
        return Colors.orange[700];
      } else if (0 <= mainGrade && mainGrade < 70) {
        return Colors.red[800];
      } else {
        return Colors.grey[600];
      }
    }

    if (studentGrade == '06' ||
        studentGrade == '07' ||
        studentGrade == '08' ||
        studentGrade == '09' ||
        studentGrade == '10' ||
        studentGrade == '11' ||
        studentGrade == '12') {
      majorMinorAvg = showAvg
          ? new WillPopScope(
              onWillPop: _willPopCallback,
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        border: Border.all(
                          color: Colors.grey[600],
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: height / 1.5,
                      width: width / 1.04,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      showAvg = false;
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                'Major\nAverage',
                                minFontSize: 18,
                                style: GoogleFonts.arimo(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: height / 7.2,
                                width: width / 2.3,
                                decoration: BoxDecoration(
                                  color: GradePage().getColor(
                                      ((majorPoints / majorTotal) * 100)
                                              .toStringAsFixed(3) +
                                          " %"),
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: AutoSizeText(
                                  ((majorPoints / majorTotal) * 100)
                                          .toStringAsFixed(3) +
                                      " %",
                                  minFontSize: 23,
                                  style: GoogleFonts.arimo(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          AutoSizeText(
                            ("# of Majors: " + avgMajorCount.toString()),
                            minFontSize: 18,
                            style: GoogleFonts.arimo(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Divider(
                            indent: width / 27,
                            endIndent: width / 27,
                            thickness: 2.4,
                            color: Colors.grey[900],
                          ),
                          Padding(
                            padding: EdgeInsets.all(7),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                'Minor\nAverage',
                                minFontSize: 18,
                                style: GoogleFonts.arimo(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: height / 7.2,
                                width: width / 2.3,
                                decoration: BoxDecoration(
                                  color: GradePage().getColor(
                                      ((minorPoints / minorTotal) * 100)
                                              .toStringAsFixed(3) +
                                          " %"),
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: AutoSizeText(
                                  ((minorPoints / minorTotal) * 100)
                                          .toStringAsFixed(3) +
                                      " %",
                                  minFontSize: 23.0,
                                  style: GoogleFonts.arimo(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          AutoSizeText(
                            ("# of Minors: " + avgMinorCount.toString()),
                            minFontSize: 18,
                            style: GoogleFonts.arimo(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : new Container();
    }

    myClassList['Assignments'].forEach((element) {
      if (myClassList['New Assignments'].contains(element)) {
        totalNum++;
      }
    });

    void checkNewGrades(assignment) {
      bool checkGrades =
          widget.dataGradePage["New Assignments"].contains(assignment);
      if (checkGrades == true) {
        newGrades = Container(
          decoration: BoxDecoration(
            color: Colors.lightGreenAccent[400],
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: EdgeInsets.all(2),
          child: AutoSizeText(
            "NEW",
            textAlign: TextAlign.center,
            maxLines: 1,
            style: GoogleFonts.roboto(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        );
      } else {
        newGrades = Container();
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg1.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        right: 15,
                        bottom: 5,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            child: IconButton(
                              tooltip: 'Exit',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 35,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Align(
                            child: IconButton(
                              tooltip: 'Extra Info',
                              onPressed: () {
                                setState(() {
                                  showInfo = true;
                                });
                              },
                              icon: Icon(
                                Icons.info_outline,
                                size: 35,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              tooltip: 'Add Grades',
                              onPressed: () {
                                if (countAdded < 6) {
                                  setState(() {
                                    countAdded++;
                                    addNew = true;
                                  });
                                } else {
                                  setState(() {
                                    additionError = true;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          height: height / 8,
                          width: width / 1.05,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.74),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding:
                                EdgeInsets.only(right: 15, left: 15, bottom: 7),
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              className,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 25,
                              style: GoogleFonts.francoisOne(
                                fontSize: 27,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(3.5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.65),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: AutoSizeText(
                                '• Last Updated: ' +
                                    date.toString() +
                                    '\n' +
                                    '• Total # of Grades: ' +
                                    countGrades.toString() +
                                    '\n' +
                                    '• # of New Grades: ' +
                                    totalNum.toString(),
                                maxFontSize: 13,
                                style: GoogleFonts.bitter(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            InkWell(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: width / 3.2,
                                    height: height / 8.2,
                                    child: AutoSizeText(
                                      totalAverage.toStringAsFixed(2),
                                      overflow: TextOverflow.clip,
                                      minFontSize: 24,
                                      style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      color: GradePage().getColor(
                                          totalAverage.toString() + '%'),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(33),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width / 5,
                                    height: height / 24,
                                    child: AutoSizeText(
                                      printText,
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: showDiff
                                        ? BoxDecoration(
                                            color: Colors.purple[300],
                                            border: Border.all(
                                              color: Colors.purple[600],
                                              width: 3.5,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          )
                                        : BoxDecoration(),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  showAvg = true;
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Divider(
                          indent: width / 28,
                          endIndent: width / 28,
                          thickness: 2.8,
                          color: Colors.grey[900],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: classAssignments.length,
                    itemBuilder: (context, index) {
                      checkNewGrades(classAssignments[index]);
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            bottom: 2.5, top: 5, left: 6.0, right: 6.0),
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
                              color: _tileColor(assignmentsCategory[index]),
                              border: Border.all(
                                color: Colors.blueGrey[900],
                                width: 2.6,
                              ),
                              borderRadius: new BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                newGrades,
                                ListTile(
                                  contentPadding: EdgeInsets.all(8),
                                  leading: IconButton(
                                    tooltip: 'Edit',
                                    alignment: Alignment.centerLeft,
                                    onPressed: () {
                                      setState(
                                        () {
                                          changeNum = index;
                                          _checkEditError(index);
                                          try {
                                            if (((_isNumeric(assignmentsGrades[
                                                                index]) ==
                                                            true ||
                                                        assignmentsGrades[
                                                                index] ==
                                                            '') &&
                                                    _isNumeric(
                                                            assignmentsTotalPoints[
                                                                index]) ==
                                                        true) &&
                                                assignmentsCategory[index] !=
                                                    'Non-graded') {
                                              editG = true;
                                              if (double.parse(
                                                      assignmentsTotalPoints[
                                                          index]) <
                                                  100) {
                                                setState(() {
                                                  assignmentsWeight[
                                                      index] = (double.parse(
                                                              assignmentsTotalPoints[
                                                                  index]) /
                                                          100)
                                                      .toString();
                                                  if (assignmentsWeightScore[
                                                          index] !=
                                                      "") {
                                                    assignmentsGrades[
                                                        index] = ((double.parse(
                                                                    assignmentsWeightScore[
                                                                        index]) /
                                                                (double.parse(
                                                                    assignmentsTotalPoints[
                                                                        index]))) *
                                                            100)
                                                        .toStringAsFixed(2);
                                                  } else {
                                                    assignmentsGrades[index] =
                                                        "";
                                                  }
                                                });
                                              }
                                              grade.text =
                                                  assignmentsGrades[index];
                                              weight.text =
                                                  assignmentsWeight[index];
                                              if (assignmentsCategory[index] ==
                                                  'Minor Grades') {
                                                _radioValChange(0);
                                              } else if (assignmentsCategory[
                                                      index] ==
                                                  'Major Grades') {
                                                _radioValChange(1);
                                              } else {
                                                _radioValChange(2);
                                              }
                                              addNew = true;
                                              editMyGrade = true;
                                            }
                                          } on FormatException {
                                            editError = true;
                                          } on TypeError {
                                            editError = true;
                                          }
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: width / 17,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  title: AutoSizeText(
                                    classAssignments[index],
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 15,
                                    maxLines: 2,
                                    style: GoogleFonts.cabin(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    height: height / 16.5,
                                    width: width / 4.2,
                                    child: AutoSizeText(
                                      assignmentsGrades[index],
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 18,
                                      maxLines: 1,
                                      style: GoogleFonts.heebo(
                                        fontWeight: FontWeight.bold,
                                        color: _assignmentGradeC(
                                            assignmentsGrades[index], index),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) => Container(
                                        height: height / 1.3,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            topLeft: Radius.circular(40),
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[700],
                                            width: 2.6,
                                          ),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 5, left: 8, right: 8),
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  classAssignments[index],
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  minFontSize: 21,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.mukta(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.black,
                                                    textStyle: TextStyle(
                                                      height: 1.7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    child: AutoSizeText(
                                                      '  Category: ',
                                                      maxLines: 1,
                                                      minFontSize: 16,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 2 * (width / 3.1),
                                                    child: AutoSizeText(
                                                      'Weighted Score: ',
                                                      maxLines: 1,
                                                      minFontSize: 16,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    height: width / 3.1,
                                                    child: AutoSizeText(
                                                      assignmentsCategory[
                                                          index],
                                                      maxLines: 2,
                                                      minFontSize: 17,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey[900],
                                                        width: 2.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      color: Colors.grey[100],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 2 * (width / 3.1),
                                                    height: width / 3.1,
                                                    child: AutoSizeText(
                                                      assignmentsWeightScore[
                                                              index] +
                                                          " / " +
                                                          assignmentsTotalPoints[
                                                              index],
                                                      maxLines: 1,
                                                      minFontSize: 17,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey[900],
                                                        width: 2.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      color: Colors.grey[100],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    child: AutoSizeText(
                                                      'Due Date: ',
                                                      maxLines: 1,
                                                      minFontSize: 16,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    child: AutoSizeText(
                                                      'Weight: ',
                                                      maxLines: 1,
                                                      minFontSize: 16,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    child: AutoSizeText(
                                                      'Percentage: ',
                                                      maxLines: 1,
                                                      minFontSize: 16,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    height: width / 3.1,
                                                    child: AutoSizeText(
                                                      assignmentsDueDate[index],
                                                      maxLines: 1,
                                                      minFontSize: 14,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey[900],
                                                        width: 2.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      color: Colors.grey[100],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    height: width / 3.1,
                                                    child: AutoSizeText(
                                                      assignmentsWeight[index],
                                                      maxLines: 1,
                                                      minFontSize: 15,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey[900],
                                                        width: 2.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      color: Colors.grey[100],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: width / 3.1,
                                                    height: width / 3.1,
                                                    child: AutoSizeText(
                                                      assignmentsPercent[index],
                                                      maxLines: 1,
                                                      minFontSize: 15,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.alata(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey[900],
                                                        width: 2.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      color: Colors.grey[100],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
          Align(
            child: past6,
            alignment: Alignment.center,
          ),
          Align(
            child: cannotEdit,
            alignment: Alignment.center,
          ),
          Align(
            child: showExtraInfo,
            alignment: Alignment.center,
          ),
          Align(
            child: newAddition,
            alignment: Alignment.center,
          ),
          Align(
            child: majorMinorAvg,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
