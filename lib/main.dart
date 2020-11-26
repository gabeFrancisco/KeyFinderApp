import 'dart:convert';
import 'dart:ui';

import 'package:KeyFinder/views/KeyView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:KeyFinder/models/Key.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //This is the list that stores the keys from the api
  List<KeyObject> _keys = List<KeyObject>();
  KeyObject _key;

  //Method to fetch the data from the API
  Future<List<KeyObject>> fetchKeys() async {
    var url = 'http://keyfinder.kinghost.net/api/keys';
    var response = await http.get(url);

    var keys = List<KeyObject>();

    if (response.statusCode == 200) {
      var keysJson = json.decode(response.body);

      for (var key in keysJson) {
        keys.add(KeyObject.fromJson(key));
      }
    }
    return keys;
  }

  Future<KeyObject> fetchSingleKey(int id) async {
    var url = 'http://keyfinder.kinghost.net/api/keys/${id}';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      _key = KeyObject.fromJson(jsonResult);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KeyView(_key)));
  }

  //When the app starts, it loads the setState method to fill the listbuilder
  //with the API
  @override
  void initState() {
    fetchKeys().then((value) {
      setState(() {
        _keys.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("${_keys.length} é o numero!");
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          actions: [
            IconButton(
              icon: Icon(Icons.sync),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  fetchKeys().then((value) {
                    setState(() {
                      _keys.clear();
                      _keys.addAll(value);
                    });
                  });
                });
              },
            )
          ],
          title: Image.asset('assets/logo.png', fit: BoxFit.cover, height: 50),
          backgroundColor: Colors.grey[800],
        ),
        body: FutureBuilder(
          future: fetchKeys(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                    child: SizedBox(
                  width: 200,
                  height: 200,
                  //alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    strokeWidth: 8.0,
                  ),
                ));
              default:
                if (snapshot.hasError)
                  return Container();
                else
                  return _returnKeyList(context, snapshot);
            }
          },
        ));
  }

  Widget _returnKeyList(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.grey[400], Colors.grey[50]]),
      ),
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              height: 70,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    fetchSingleKey(_keys[index].keyId);
                    print(_key.model);
                  });
                },
                color: Colors.grey[100],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _keys[index].model,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_keys[index].manufactor,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    )),
                                Text(
                                  _keys[index].year,
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              colors: [Colors.green[600], Colors.green[400]])),
                      child: Text(
                        "R\$${_keys[index].price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: _keys.length),
    );
  }
}
