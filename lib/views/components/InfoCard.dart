import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  String message;

  InfoCard(this.message);
  TextStyle globalStyle = new TextStyle(
    fontSize: 20,
    color: Colors.black
    );

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[400], Colors.grey[100]]
          ),
          border: Border(
              top: BorderSide(width: 1, color: Colors.black),
              bottom: BorderSide(width: 1, color: Colors.black)),
        ),
        padding: EdgeInsets.all(10),
        child: Text(message, style: globalStyle,));
  }
}
