import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'home_app.dart';
import 'grades_app.dart';
import 'extra_app.dart';
import 'settings_app.dart';
import 'package:flutter/services.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.black,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      title: 'Grade Genius',
      theme: ThemeData(
        primaryColor: Colors.cyan,
      ),
      home: SplashScreen(
        'assets/splashIntro.flr',
        MyLoginPage(),
        startAnimation: 'Untitled',
        backgroundColor: Colors.black,
      ),
    );
  }
}

// List<Slide> slides = new List();
// class MyIntroScreen extends StatefulWidget {
//   @override
//   _IntroPage createState() => _IntroPage();
// }

// class _IntroPage extends State<MyIntroScreen> {
//   Future<bool> _willPopCallback() async {
//     return false;
//   }

//   @override
//   void initState() {
//     super.initState();

//     Shader linearGradient = LinearGradient(
//       colors: <Color>[
//         Colors.red[900],
//         Colors.yellow[700],
//         Colors.greenAccent[700],
//         Colors.blue[700],
//         Colors.purple,
//         Colors.pink[300],
//       ],
//     ).createShader(
//       Rect.fromLTWH(0.0, 0.0, 275.0, 0),
//     );

//     Shader linearGradient1 = LinearGradient(
//       colors: <Color>[
//         Colors.red[900],
//         Colors.orangeAccent[700],
//         Colors.amber,
//         Colors.green[400],
//       ],
//     ).createShader(
//       Rect.fromLTWH(0.0, 0.0, 275.0, 0),
//     );

//     Shader linearGradient2 = LinearGradient(
//       colors: <Color>[
//         Colors.yellow[700],
//         Colors.greenAccent[400],
//         Colors.teal[400],
//         Colors.lightBlue[400],
//       ],
//     ).createShader(
//       Rect.fromLTWH(0.0, 0.0, 275.0, 0),
//     );

//     Shader linearGradient3 = LinearGradient(
//       colors: <Color>[
//         Colors.blueAccent[700],
//         Colors.indigo[600],
//         Colors.purple,
//         Colors.pink[300],
//       ],
//     ).createShader(
//       Rect.fromLTWH(0.0, 0.0, 275.0, 0),
//     );

//     slides.add(
//       new Slide(
//         widgetTitle: RichText(
//           textAlign: TextAlign.left,
//           text: TextSpan(
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.black,
//             ),
//             children: <TextSpan>[
//               TextSpan(
//                 text: "Welcome To\n\n",
//                 style: GoogleFonts.calistoga(
//                   color: Colors.black,
//                   fontSize: 33,
//                 ),
//               ),
//               TextSpan(
//                 text: "GRADE GENIUS.",
//                 style: GoogleFonts.calistoga(
//                   textStyle: TextStyle(
//                     shadows: <Shadow>[
//                       Shadow(
//                         offset: Offset(7, 5),
//                         blurRadius: 3.0,
//                         color: Colors.grey[200],
//                       ),
//                     ],
//                     foreground: Paint()..shader = linearGradient,
//                     height: .9,
//                     letterSpacing: 2,
//                   ),
//                   color: Colors.black,
//                   fontSize: 44,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         widthImage: 115,
//         heightImage: 115,
//         pathImage: "assets/AtomImage.JPG",
//         widgetDescription: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.only(left: 10, bottom: 10),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "SWIFT.",
//                 style: GoogleFonts.calistoga(
//                   textStyle: TextStyle(
//                     shadows: <Shadow>[
//                       Shadow(
//                         offset: Offset(7, 5),
//                         blurRadius: 3.0,
//                         color: Colors.grey[200],
//                       ),
//                     ],
//                     foreground: Paint()..shader = linearGradient1,
//                     height: .9,
//                     letterSpacing: 2,
//                   ),
//                   fontSize: 40,
//                 ),
//               ),
//             ),
//             Container(
//               alignment: Alignment.center,
//               child: Text(
//                 "SMART.",
//                 style: GoogleFonts.calistoga(
//                   textStyle: TextStyle(
//                     shadows: <Shadow>[
//                       Shadow(
//                         offset: Offset(7, 5),
//                         blurRadius: 3.0,
//                         color: Colors.grey[200],
//                       ),
//                     ],
//                     foreground: Paint()..shader = linearGradient2,
//                     height: 1.3,
//                     letterSpacing: 2,
//                   ),
//                   color: Colors.black,
//                   fontSize: 40,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(right: 10, top: 10),
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "SIMPLE.",
//                 style: GoogleFonts.calistoga(
//                   textStyle: TextStyle(
//                     shadows: <Shadow>[
//                       Shadow(
//                         offset: Offset(7, 5),
//                         blurRadius: 3.0,
//                         color: Colors.grey[200],
//                       ),
//                     ],
//                     foreground: Paint()..shader = linearGradient3,
//                     height: 1.3,
//                     letterSpacing: 2,
//                   ),
//                   color: Colors.black,
//                   fontSize: 40,
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 35),
//               alignment: Alignment.center,
//               child: Text(
//                 "HAC Reimagined.",
//                 style: GoogleFonts.calistoga(
//                   color: Colors.grey[800],
//                   fontSize: 27,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//       ),
//     );
//   }

//   void onSkipPress() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => MyLoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _willPopCallback,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             IntroSlider(
//               slides: slides,
//               onDonePress: this.onSkipPress,
//               colorDoneBtn: Colors.grey[600],
//               colorSkipBtn: Colors.grey[600],
//               nameDoneBtn: "Continue",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyLoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class DataInfo {
  bool showInfo;
  bool userBool;
  bool passBool;
  String username;
  String password;
  List dateList;
  String user;
  String studentGrade;
  String studentName;
  String studentID;
  String studentSchool;
  String reportRun;
  Map classAverages;
  Map classAssignments;
  List myCookies;
  List newAssignments;
  List newScores;
  List newClasses;
  DataInfo({
    this.showInfo,
    this.userBool,
    this.passBool,
    this.username,
    this.password,
    this.dateList,
    this.user,
    this.studentGrade,
    this.studentID,
    this.studentName,
    this.studentSchool,
    this.reportRun,
    this.classAverages,
    this.classAssignments,
    this.myCookies,
    this.newAssignments,
    this.newScores,
    this.newClasses,
  });
}

class _LoginPage extends State<MyLoginPage> {
  String loginUrl = '';
  var infoList = '';
  var username = TextEditingController();
  var password = TextEditingController();
  List<Cookie> myCookies = [];

  // local Android host url = 'http://10.0.2.2:5000/'
  // app url = 'https://gradegenius.org/'
  String host = 'https://gradegenius.org/';
  bool isLoggedIn = false;
  bool gotInfo = false;
  var client = HttpClient();
  bool textVisible = false;
  bool isLoading = false;
  String errorMessage = '';
  String user = '';
  String pass = '';
  bool isError = false;
  bool gradeError = false;
  bool isWelcome = true;
  String userPassError;
  bool _obscureText = true;
  bool displayLoad = false;
  var loginButton;
  var dataLoginPage;
  bool error = false;
  String oldClassString = "";
  String currentClassString = "";
  Map oldMap;
  Map currentMap;
  String oldC = "";
  String currentC = "";
  Map oldClassesMap;
  Map currentClassesMap;
  List diffAssignments = [];
  List diffScores = [];
  List diffClasses = [];
  String oldReportRun = "";
  int dropdownValue = 1;
  bool forgotInfo = false;
  bool tNc = false;

  Future<HttpClientResponse> makeRequest(
      Uri uri, List<Cookie> requestCookies) async {
    var request = await client.getUrl(uri);
    print(uri);
    request.cookies.addAll(requestCookies);
    request.followRedirects = false;
    return await request.close();
  }

  Future mainInfo(loginUrl) async {
    var response = await makeRequest(
      Uri.parse(loginUrl),
      [Cookie('user', user), (Cookie('pass', pass))],
    );
    if (response.statusCode == 401) {
      setState(() {
        isLoggedIn = false;
      });
    } else {
      setState(() {
        isLoading = true;
        textVisible = false;
      });
      Uri location = Uri.parse(response.headers[HttpHeaders.locationHeader][0]);
      setState(() {
        myCookies = response.cookies;
      });
      setState(() {
        isLoggedIn = true;
      });
      response = await makeRequest(location, response.cookies);
      if (response.statusCode == 404 || response.statusCode == 500) {
        setState(() {
          displayLoad = false;
          isLoading = false;
          gradeError = true;
          gotInfo = true;
          errorMessage =
              'HAC Servers are probably down. Please try again later.';
        });
      }
      final completer = Completer<String>();
      final contents = StringBuffer();
      response.transform(utf8.decoder).listen((data) {
        contents.write(data);
      }, onDone: () => completer.complete(contents.toString()));
      return await completer.future;
    }
  }

  Future<bool> _willPopCallback() async {
    return false;
  }

  addStringToSF(oldString, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name + ' oldClassString', oldString);
  }

  getStringValuesSF(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.get(name + ' oldClassString');
    return (stringValue.toString());
  }

  checkAvailable(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkVal = prefs.containsKey(name + ' oldClassString');
    return checkVal;
  }

  addStringToSF2(oldString, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name + ' oldClasses', oldString);
  }

  getStringValuesSF2(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.get(name + ' oldClasses');
    return (stringValue.toString());
  }

  checkAvailable2(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkVal = prefs.containsKey(name + ' oldClasses');
    return checkVal;
  }

  addRun(oldRun, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name + ' run', oldRun);
  }

  getRun(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.get(name + ' run');
    return (stringValue.toString());
  }

  checkAvailableRun(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkVal = prefs.containsKey(name + ' run');
    return checkVal;
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.get('username save');
    return (stringValue.toString());
  }

  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkVal = prefs.containsKey('username save');
    return checkVal;
  }

  getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.get('password save');
    return (stringValue.toString());
  }

  checkPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkVal = prefs.containsKey('password save');
    return checkVal;
  }

  getUserBool(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolVal = prefs.get(name + ' username bool');
    return boolVal;
  }

  getPassBool(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolVal = prefs.get(name + ' password bool');
    return boolVal;
  }

  checkUserBool(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkVal = prefs.containsKey(name + ' username bool');
    return checkVal;
  }

  checkPassBool(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkVal = prefs.containsKey(name + ' password bool');
    return checkVal;
  }

  addUserToSF(username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username save', username);
  }

  addPassToSF(password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password save', password);
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
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    differenceMethod() async {
      List oldAssignments = [];
      List oldScores = [];
      List oldClasses = [];
      List currAssignments = [];
      List currScores = [];
      List currClasses = [];

      String studentName = dataLoginPage.studentName;
      String currentReportRun = dataLoginPage.reportRun;
      try {
        if (checkAvailableRun(studentName) == false) {
          await addRun(currentReportRun, studentName);
        }
        if (checkAvailable(studentName) == false &&
            checkAvailable2(studentName) == false) {
          await addStringToSF(
              (json.encode(dataLoginPage.classAssignments).toString()),
              studentName);
          await addStringToSF2(
              (json.encode(dataLoginPage.classAverages).toString()),
              studentName);
        } else {
          oldReportRun = await getRun(studentName);
          if (currentReportRun == oldReportRun) {
            currentClassString =
                json.encode(dataLoginPage.classAssignments).toString();
            oldClassString = await getStringValuesSF(studentName);
            currentC = json.encode(dataLoginPage.classAverages).toString();
            oldC = await getStringValuesSF2(studentName);
            await addRun(currentReportRun, studentName);
            await addStringToSF2(
                (json.encode(dataLoginPage.classAverages).toString()),
                studentName);
            await addStringToSF(
                (json.encode(dataLoginPage.classAssignments).toString()),
                studentName);

            oldMap = await json.decode(oldClassString);
            currentMap = await json.decode(currentClassString);
            oldClassesMap = await json.decode(oldC);
            currentClassesMap = await json.decode(currentC);

            for (int index = 0;
                index < currentClassesMap['Class Name'].length;
                index++) {
              String indexName = "Class " + (index + 1).toString();
              oldAssignments.add(oldMap[indexName]['Assignments']);
              oldScores.add(oldMap[indexName]['Score']);
              oldClasses.add(oldClassesMap['Class Name'][index]);
              currAssignments.add(currentMap[indexName]['Assignments']);
              currScores.add(currentMap[indexName]['Score']);
              currClasses.add(currentClassesMap['Class Name'][index]);
            }
          } else {
            currentClassString =
                json.encode(dataLoginPage.classAssignments).toString();
            currentC = json.encode(dataLoginPage.classAverages).toString();
            await addRun(currentReportRun, studentName);
            await addStringToSF2(
                (json.encode(dataLoginPage.classAverages).toString()),
                studentName);
            await addStringToSF(
                (json.encode(dataLoginPage.classAssignments).toString()),
                studentName);

            currentMap = await json.decode(currentClassString);
            currentClassesMap = await json.decode(currentC);

            for (int index = 0;
                index < currentClassesMap['Class Name'].length;
                index++) {
              String indexName = "Class " + (index + 1).toString();
              currAssignments.add(currentMap[indexName]['Assignments']);
              currScores.add(currentMap[indexName]['Score']);
              currClasses.add(currentClassesMap['Class Name'][index]);
            }

            oldAssignments = [];
            oldScores = [];
            oldClasses = [];

            for (int index = 0;
                index < currentClassesMap['Class Name'].length;
                index++) {
              oldAssignments.add([]);
              oldScores.add([]);
              oldClasses.add("");
            }
          }
        }
        int value = 0;
        for (int index = 0; index < currAssignments.length; index++) {
          value = 0;
          currAssignments[index].forEach((element) {
            if (!oldAssignments[index].contains(element)) {
              diffAssignments.add(element);
              diffScores.add(currScores[index][value]);
              diffClasses.add(currClasses[index]);
            }
            value++;
          });
        }
      } on RangeError {
        setState(() {
          error = true;
          diffAssignments = [];
          diffScores = [];
          diffClasses = [];
        });
      } on NoSuchMethodError {
        setState(() {
          error = true;
          diffAssignments = [];
          diffScores = [];
          diffClasses = [];
        });
      } on FormatException {
        setState(() {
          error = true;
          diffAssignments = [];
          diffScores = [];
          diffClasses = [];
        });
      } on Error {
        setState(() {
          error = true;
          diffAssignments = [];
          diffScores = [];
          diffClasses = [];
        });
      }
    }

    if (displayLoad == false) {
      loginButton = Container(
        child: InkWell(
          child: Container(
            width: width / 1.5,
            height: height / 16,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.orangeAccent[700],
                  Colors.redAccent[400],
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AutoSizeText(
              'LOGIN',
              minFontSize: 18,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onTap: () async {
            try {
              setState(() {
                user = username.text;
                user = user.trim();
                pass = password.text;
                pass = pass.trim();
                loginUrl = host + 'login';
              });
              setState(() {
                errorMessage = '';
                gotInfo = false;
                _obscureText = true;
                displayLoad = true;
              });
              FocusScope.of(context).unfocus();
              var gradesList = '';
              if (loginUrl == '' || user == '' || pass == '') {
                setState(() {
                  isError = true;
                });
              }
              if (isError == false) {
                gradesList = await mainInfo(loginUrl);
              }
              if (isLoggedIn == true && gradeError == false) {
                setState(() {
                  gotInfo = true;
                });
                Map infoMap;
                Map averagesMap;
                Map assignmentsMap;
                List dates;
                var currMap;
                String reportRun;
                setState(
                  () {
                    currMap = json.decode(gradesList);
                    infoMap = currMap['Info'];
                    averagesMap = currMap['Averages'];
                    dates = currMap["Date List"];
                    assignmentsMap = currMap['Grades'];
                    reportRun = currMap['Report Run'];
                  },
                );
                dataLoginPage = DataInfo(
                  dateList: dates,
                  user: user,
                  studentGrade: (infoMap['Grade']),
                  studentName: (infoMap['Name']),
                  studentID: (infoMap['ID']),
                  studentSchool: (infoMap['Home Campus']),
                  reportRun: (reportRun),
                  classAverages: averagesMap,
                  classAssignments: assignmentsMap,
                  myCookies: myCookies,
                );
                await differenceMethod();
                bool userBoolMain = false;
                bool passBoolMain = false;
                if (await checkUserBool(infoMap['Name']) == true) {
                  userBoolMain = await getUserBool(infoMap['Name']);
                }
                if (await checkPassBool(infoMap['Name']) == true) {
                  passBoolMain = await getPassBool(infoMap['Name']);
                }
                if (userBoolMain == false) {
                  await addUserToSF("");
                } else {
                  await addUserToSF(user);
                }
                if (passBoolMain == false) {
                  await addPassToSF("");
                } else {
                  await addPassToSF(pass);
                }
                final dataLoginPage2 = DataInfo(
                  dateList: dates,
                  user: user,
                  studentGrade: (infoMap['Grade']),
                  studentName: (infoMap['Name']),
                  studentID: (infoMap['ID']),
                  studentSchool: (infoMap['Home Campus']),
                  reportRun: (reportRun),
                  classAverages: averagesMap,
                  classAssignments: assignmentsMap,
                  myCookies: myCookies,
                  newAssignments: diffAssignments,
                  newScores: diffScores,
                  newClasses: diffClasses,
                  username: user,
                  password: pass,
                  userBool: userBoolMain,
                  passBool: passBoolMain,
                  showInfo: true,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyWelcomePage(
                      dataHomePage: dataLoginPage2,
                    ),
                  ),
                );
              }
              if (gotInfo == false) {
                setState(() {
                  displayLoad = false;
                  textVisible = true;
                  password.clear();
                  errorMessage =
                      'Username and/or password is incorrect. Please try again.';
                  isError = false;
                });
              }
            } on NoSuchMethodError {
              gradeError = true;
              isLoading = false;
            } on HttpException {
              gradeError = true;
              isLoading = false;
            } on Error {
              gradeError = true;
              isLoading = false;
            }
          },
        ),
      );
    } else {
      loginButton = Center(
        child: SizedBox(
          height: 20.0,
          child: SpinKitWave(
            color: Colors.grey,
          ),
        ),
      );
    }

    var loadingIndicator = isLoading
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
                          borderRadius: BorderRadius.circular(10.0)),
                      width: width,
                      height: height,
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
                            margin: EdgeInsets.only(top: width / 29),
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

    var showTerms = tNc
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
                        height: height / 4,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Please visit the app/play store to view the Terms and Conditions (Terms of Service).',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          tNc = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    var forgotContainer = forgotInfo
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
                          'If you have forgotten the credentials to your HAC account, please visit the HAC website in order to possibly reset your username and/or password.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          forgotInfo = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    var serverDown = gradeError
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
                          'Grade Genius could not load the data. The HAC servers are probably down. Please try again later.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          displayLoad = false;
                          gradeError = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : new Container();

    Shader linearGradient1 = LinearGradient(
      colors: <Color>[
        Colors.red[900],
        Colors.orangeAccent[700],
        Colors.amber,
        Colors.green[400],
      ],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 275.0, 0),
    );

    Shader linearGradient2 = LinearGradient(
      colors: <Color>[
        Colors.greenAccent[400],
        Colors.teal[300],
        Colors.cyan[400],
        Colors.purple[400],
        Colors.pinkAccent,
      ],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 300.0, 0),
    );

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'GRADE',
                    style: GoogleFonts.galindo(
                      textStyle: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(7, 5),
                            blurRadius: 3.0,
                            color: Colors.grey[300],
                          ),
                        ],
                        foreground: Paint()..shader = linearGradient1,
                        fontSize: height / 21,
                        height: 1,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/AtomImage.JPG',
                  width: width / 2.4,
                  height: height / 4.8,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'GENIUS',
                    style: GoogleFonts.galindo(
                      textStyle: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(7, 5),
                            blurRadius: 3.0,
                            color: Colors.grey[300],
                          ),
                        ],
                        foreground: Paint()..shader = linearGradient2,
                        fontSize: height / 21,
                        height: 1.2,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(height / 140),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                            ),
                          ),
                          child: Container(
                            child: TextField(
                              maxLines: 1,
                              controller: username,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                                contentPadding: EdgeInsets.all(25.0),
                              ),
                              style: GoogleFonts.scada(
                                textStyle: TextStyle(
                                  letterSpacing: 1.4,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                        ),
                        Material(
                          elevation: 25,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  maxLines: 1,
                                  controller: password,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    contentPadding: EdgeInsets.all(25.0),
                                  ),
                                  obscureText: _obscureText,
                                  style: GoogleFonts.scada(
                                    textStyle: TextStyle(
                                      letterSpacing: 1.4,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.go,
                                ),
                              ),
                              IconButton(
                                onPressed: _toggle,
                                icon: Icon(Icons.remove_red_eye),
                                iconSize: 27,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: AutoSizeText(
                        "Forgot Credentials",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      hoverColor: Colors.white70,
                      onTap: () {
                        setState(() {
                          forgotInfo = true;
                        });
                      },
                    ),
                    InkWell(
                      child: AutoSizeText(
                        "Autofill",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      hoverColor: Colors.white70,
                      onTap: () async {
                        bool userThere = await checkUser();
                        bool passThere = await checkPass();
                        if (userThere == true) {
                          String myStr = await getUser();
                          setState(() {
                            username.text = myStr;
                          });
                        }
                        if (passThere == true) {
                          String myStr = await getPass();
                          setState(() {
                            password.text = myStr;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(7),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: AutoSizeText(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.heebo(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.red[600],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                loginButton,
                Padding(
                  padding: EdgeInsets.all(4),
                ),
                InkWell(
                  child: Container(
                    width: width / 1.5,
                    height: height / 16,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent[400],
                          Colors.teal[300],
                          Colors.cyan[400],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: AutoSizeText(
                      'Terms of Service',
                      minFontSize: 18,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      tNc = true;
                    });
                  },
                ),
              ],
            ),
            Align(
              child: showTerms,
              alignment: FractionalOffset.center,
            ),
            Align(
              child: forgotContainer,
              alignment: FractionalOffset.center,
            ),
            Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
            Align(
              child: serverDown,
              alignment: FractionalOffset.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MyWelcomePage extends StatefulWidget {
  final DataInfo dataHomePage;
  MyWelcomePage({this.dataHomePage});

  @override
  WelcomePage createState() => WelcomePage();
}

class WelcomePage extends State<MyWelcomePage> {
  Future<bool> _willPopCallback() async {
    return false;
  }

  int _selectedTabIndex = 0;

  Widget callPage(_selectedTabIndex) {
    switch (_selectedTabIndex) {
      case 0:
        return MyHomeApp(
          dataHomePage2: widget.dataHomePage,
        );
      case 1:
        return MyGradePage(
          dataGrades: widget.dataHomePage,
        );
      case 2:
        return MyExtrasPage(
          dataExtras: widget.dataHomePage,
        );
      case 3:
        return MySettingsApp(
          settingsData: widget.dataHomePage,
        );
        break;
      default:
        return MyHomeApp(
          dataHomePage2: widget.dataHomePage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey.withOpacity(.6),
      statusBarColor: Colors.grey.withOpacity(.6),
    ));
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: callPage(_selectedTabIndex),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedTabIndex,
          showElevation: true,
          containerHeight: height / 12.5,
          onItemSelected: (index) => setState(() {
            _selectedTabIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text(
                'Home',
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                      fontSize: 18.0,
                      height: 1.2,
                      color: Colors.cyanAccent[700]),
                ),
              ),
              activeColor: Colors.cyanAccent[700],
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.assignment),
              title: Text(
                'Grades',
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    height: 1.2,
                    color: Colors.red[400],
                  ),
                ),
              ),
              activeColor: Colors.red[400],
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.school),
              title: Text(
                'Extra',
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    height: 1.2,
                    color: Colors.amber,
                  ),
                ),
              ),
              activeColor: Colors.amber,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    height: 1.2,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
              activeColor: Colors.blueGrey[800],
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
