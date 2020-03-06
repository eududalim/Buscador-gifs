import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null)
      // Se _search for nula retorne os melhores Gifs
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=yX6HxlIjMByJC9l16e3tmBzpU35sqsT9&limit=20&rating=G');
    else
      // Se não, retorne a pesquisa dos gifs pelo que está dentro do _search
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=yX6HxlIjMByJC9l16e3tmBzpU35sqsT9&q=$_search&limit=20&offset=$_offset&rating=G&lang=pt');

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              // Logo do Giphy developers
              'https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField( 
              // Caixa de pesquisa
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                labelText: "Pesquise aqui",
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                  ),                
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container( // Carregamento
                          height: 200.0,
                          width: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(                            
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );                      
                      break;
                    default:
                    if (snapshot.hasError) return Container();
                    else _createGifTable(context, snapshot);
                  }
                },
              ),
            )
          ],
        )
    );
  }

  Widget _createGifTable (context, snapshot) {
    return Container();
  }

}
