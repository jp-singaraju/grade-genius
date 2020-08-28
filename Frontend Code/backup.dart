import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());
bool followRedirects = true;
bool persistentConnection = true;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String url;

  String urlReal;

  var Data;

  String infoContent;

  // Future<void> main(url) async {
  //    http.Response response = await http.get("http://10.0.2.2:5000/main?username=Singaraju.J&password=pran2004!");

  //    print(response.statusCode);
  //    print(response.body);

  var client;

  Future<HttpClientResponse> makeRequest(Uri uri, List<Cookie> cookies) async {
    var request = await client.openUrl('GET', uri);
    request.cookies.addAll(cookies);
    request.followRedirects = false;
    return await request.close();
  }

  main() async {
    client = new HttpClient();
    var response = await makeRequest(
        Uri.parse(
            "http://10.0.2.2:5000/main?username=Singaraju.J&password=pran2004!"),
        []);
    if (response.statusCode == HttpStatus.found) {
      Uri location = Uri.parse(response.headers[HttpHeaders.locationHeader][0]);
      response = await makeRequest(location, response.cookies);
      response.transform(utf8.decoder).listen((contents) {
         print(contents);
       });
    }
  }

  //   await HttpClient()
  //   .getUrl(Uri.parse(url))
  //   .then((HttpClientRequest request) {
  //     request.followRedirects = true;

  //     request.close();
  //   })
  //   .then((HttpClientResponse response) =>
  //       response.transform(utf8.decoder).listen(print));*/

  // }

  String QueryText = 'Grade';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('LOGIN'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  urlReal =
                      "http://10.0.2.2:5000/login?username=Singaraju.J&password=" +
                          value.toString();
                },
                decoration: InputDecoration(
                    hintText: 'Search Anything Here',
                    suffixIcon: GestureDetector(
                        onTap: () {
                          main();
                        },
                        child: Icon(Icons.search))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                QueryText,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
