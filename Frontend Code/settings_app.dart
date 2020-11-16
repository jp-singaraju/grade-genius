import 'package:flutter/material.dart';
import 'dart:io';
import 'main.dart';
import 'dart:convert';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MySettingsApp extends StatefulWidget {
  final DataInfo settingsData;
  MySettingsApp({this.settingsData});

  @override
  SettingsApp createState() => SettingsApp();
}

class SettingsApp extends State<MySettingsApp> {
  var client = HttpClient();
  List<Cookie> myCookies = [];
  bool isSwitchedUser = false;
  bool isSwitchedPass = false;

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
      myCookies = widget.settingsData.myCookies;
    });
    var response = await makeRequest(Uri.parse(urlReceiver), myCookies);
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return await completer.future;
  }

  addUserToSF(username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username save', username);
  }

  addPassToSF(password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password save', password);
  }

  addUserBool(userBool, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name + ' username bool', userBool);
  }

  addPassBool(passBool, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name + ' password bool', passBool);
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

    isSwitchedUser = widget.settingsData.userBool;
    isSwitchedPass = widget.settingsData.passBool;

    var info = widget.settingsData.showInfo
        ? new WillPopScope(
            onWillPop: _willPopCallback,
            child: Container(
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                color: Colors.white70.withOpacity(.96),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.grey[900],
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.all(15),
                width: width / 1.1,
                height: height / 1.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        "Note\n",
                        minFontSize: 26,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "• The AutoFill feature allows you to choose whether or not you want your username and/or password saved.\n",
                        minFontSize: 14,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "• Please contact the provided email as soon as possible in order to report a bug.\n",
                        minFontSize: 14,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        "• Please rate and review the app on the app/play store. Thank You for using Grade Genius!\n",
                        minFontSize: 14,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: AutoSizeText("Continue"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        if (isSwitchedUser == false) {
                          await addUserToSF("");
                        } else {
                          await addUserToSF(widget.settingsData.username);
                        }
                        if (isSwitchedPass == false) {
                          await addPassToSF("");
                        } else {
                          await addPassToSF(widget.settingsData.password);
                        }
                        setState(() {
                          widget.settingsData.showInfo = false;
                        });
                        await addUserBool(
                            isSwitchedUser, widget.settingsData.studentName);
                        await addPassBool(
                            isSwitchedPass, widget.settingsData.studentName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        : new Container();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 35),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: AutoSizeText(
                    "Preferences:",
                    minFontSize: 20,
                    style: GoogleFonts.cabin(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "Remember Username?",
                      minFontSize: 15,
                      style: GoogleFonts.cabin(
                        color: Colors.grey[900],
                      ),
                    ),
                    Switch(
                      value: isSwitchedUser,
                      onChanged: (value) async {
                        if (value == false) {
                          await addUserToSF("");
                        } else {
                          await addUserToSF(widget.settingsData.username);
                        }
                        await addUserBool(
                            value, widget.settingsData.studentName);
                        widget.settingsData.userBool = value;
                        setState(() {
                          isSwitchedUser = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "Remember Password?",
                      minFontSize: 15,
                      style: GoogleFonts.cabin(
                        color: Colors.grey[900],
                      ),
                    ),
                    Switch(
                      value: isSwitchedPass,
                      onChanged: (value) async {
                        if (value == false) {
                          await addPassToSF("");
                        } else {
                          await addPassToSF(widget.settingsData.password);
                        }
                        await addPassBool(
                            value, widget.settingsData.studentName);
                        widget.settingsData.passBool = value;
                        setState(() {
                          isSwitchedPass = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: AutoSizeText(
                    "If the username and/or password slots are switched on, the login info will already be saved next time the user logs in.",
                    minFontSize: 14,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cabin(
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15, bottom: 10, top: 15),
                  child: AutoSizeText(
                    "About App:",
                    minFontSize: 20,
                    style: GoogleFonts.cabin(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: AutoSizeText(
                    "• Designed by Jathin Pranav Singaraju and intended for use by only Frisco ISD students. \n\n • Please read and adhere to the Terms of Service on the login page and in the app/play store. \n\n • If there are any questions, inquiries, concerns, and/or bugs, please contact  gradegenius.edu@gmail.com  immediately.",
                    minFontSize: 14,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cabin(
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topCenter,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    onPressed: () async {
                      await mainRequest(host + "logout");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyLoginPage()),
                      );
                    },
                    color: Colors.red[400],
                    child: Container(
                      alignment: Alignment.center,
                      width: width / 1.5,
                      height: height / 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AutoSizeText(
                        "LOGOUT",
                        minFontSize: 16,
                        style: GoogleFonts.cabin(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            child: info,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
