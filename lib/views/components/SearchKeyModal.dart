import 'package:flutter/material.dart';

class SearchKeyModal extends StatefulWidget {

  @override
  _SearchKeyModalState createState() => _SearchKeyModalState();
}

class _SearchKeyModalState extends State<SearchKeyModal> {
  TextEditingController searchText = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
            height: 400,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: "Pesquisa um modelo aqui",
                            labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.green[400])),
                                    focusedBorder: UnderlineInputBorder(
                                       borderSide: new BorderSide(color: Colors.green[400])
              ), ),
                        controller: searchText,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        child: Text("Pesquisar"),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context, searchText.text);
                            searchText.text = "";
                          });
                        },
                      ),
                    )
                  ],
                ),
              ],
            )));
  }
}