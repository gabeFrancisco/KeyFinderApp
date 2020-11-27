import 'dart:ui';

import 'package:KeyFinder/models/Key.dart';
import 'package:KeyFinder/views/components/InfoCard.dart';
import 'package:flutter/material.dart';

class KeyView extends StatelessWidget {
  KeyObject _key;
  KeyView(this._key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_key.model),
        toolbarHeight: 70,
        backgroundColor: Colors.grey[800],
      ),
      body: ListView(
              children: [ Container(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.only(bottom: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoCard("Marca: ${_key.manufactor}"),
                  InfoCard("Modelo: ${_key.model}"),
                  InfoCard("Tipo: ${_key.type}"),
                  InfoCard("Serviço: ${_key.serviceType}"),
                  InfoCard("Ano: ${_key.year}"),
                  InfoCard("Botões: ${_key.buttons}"),
                  InfoCard("Preço: ${_key.price}"),
                  Container(
                    margin: EdgeInsets.only(top: 3, right: 1, bottom: 20, left: 1),
                    height: 100,
                    child: Card(
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(_key.observation),
                      )
                    ),
                  )
                ],
              ),
            )),]
      ),
    );
  }
}
