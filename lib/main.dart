import 'dart:convert';
import 'dart:ui';

import 'package:KeyFinder/views/KeyView.dart';
import 'package:KeyFinder/views/components/SearchKeyModal.dart';
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

  Future<List<KeyObject>> fetchSearchedKeys(String model) async {
    var url = 'http://keyfinder.kinghost.net/api/keys/search/${model}';
    var response = await http.get(url);

    var keys = List<KeyObject>();

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);

      for (var key in jsonResult) {
        keys.add(KeyObject.fromJson(key));
      }
    }
    _keys.clear();
    return keys;
  }

  void searchModel(str) {
    fetchSearchedKeys(str).then((value) {
      setState(() {
        if(value == []){
          return Center(
            child: Text("Nenhuma chave encontrada!"),
          );
        }
        _keys.clear();
        _keys.addAll(value);
        print(value);
      });
    });
  }

  void returnKeys(context) {
    fetchKeys().then((value) {
      setState(() {
        _keys.clear();
        _keys.addAll(value);
      });
    });
  }

  void returnSingleKey(index) {
    setState(() {
      fetchSingleKey(_keys[index].keyId);
      print(_key.model);
    });
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) {
                    return SearchKeyModal();
                  }).then((str) {
                if (str == null || str == "") {
                } else {
                  searchModel(str);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sync),
            color: Colors.white,
            onPressed: () {
              returnKeys(context);
            },
          ),
        ],
        title: Image.asset('assets/logo.png', fit: BoxFit.cover, height: 50),
        backgroundColor: Colors.grey[900],
      ),
      body: FutureBuilder(
        future: fetchKeys(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Container(
                width: 1000,
                height: 1000,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[400]),
                  strokeWidth: 5.0,
                ),
              );
            default:
              if (snapshot.hasError)
                return Container();
              else
                return _returnKeyList(context, snapshot);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green[400],
        items: [
          BottomNavigationBarItem(
            label: "Chaves",
            icon: Icon(Icons.vpn_key_outlined)
          ),
          BottomNavigationBarItem(
            label: "Checklist",
            icon: Icon(Icons.camera_alt)
          ),
          BottomNavigationBarItem(
            label: "Serviços",
            icon: Icon(Icons.home_repair_service)
          )
        ],
      ),
    );
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
                  const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
              height: 65,
              child: RaisedButton(
                onPressed: () {
                  returnSingleKey(index);
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
                              colors: [Colors.green[600], Colors.green[300]])),
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
