import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'main.dart';

class MyExtrasPage extends StatefulWidget {
  final DataInfo dataExtras;
  MyExtrasPage({this.dataExtras});

  @override
  ExtraApp createState() => ExtraApp();
}

class ExtraApp extends State<MyExtrasPage> {
  var client = HttpClient();
  List<Cookie> myCookies = [];
  var iprList = '';
  Map iprMap;
  var rcList = '';
  Map rcMap;
  var scheduleList = '';
  Map scheduleMap;

  // local Android host url = 'http://10.0.2.2:5000/'
  // app url = 'https://inductive-seat-277103.uc.r.appspot.com/'
  String host = 'http://10.0.2.2:5000/';

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
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  iprList = await mainRequest(host + 'ipr');
                  setState(
                    () {
                      iprMap = json.decode(iprList);
                      print(iprMap);
                    },
                  );
                },
                label: Text('IPR'),
                backgroundColor: Colors.amber,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  rcList = await mainRequest(host + 'reportcard');
                  setState(
                    () {
                      rcMap = json.decode(rcList);
                      print(rcMap);
                    },
                  );
                },
                label: Text('Report Card'),
                backgroundColor: Colors.amber,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  scheduleList = await mainRequest(host + 'schedule');
                  setState(
                    () {
                      scheduleMap = json.decode(scheduleList);
                      print(scheduleMap);
                    },
                  );
                },
                label: Text('Schedule'),
                backgroundColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
