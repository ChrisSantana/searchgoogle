import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search_google/model/data_model.dart';
import 'package:search_google/screen/result_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _urlLogo = 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png';
  final _uriAPI = 'http://webapichristiano.azurewebsites.net/api/get-consulta/';
  String _search;

  TextEditingController _editingController = new TextEditingController();

  Future<List<DataModel>> _getSearch() async {
    var response = await http.get(_uriAPI+_search);

    var jsonData = json.decode(response.body);

    List<DataModel> lista = [];
    for (var value in jsonData) {
      DataModel data = DataModel(value['Titulo'], value['URL']);
      lista.add(data);
    }
    
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Image.network(
            _urlLogo,
            fit: BoxFit.fill,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[100],
        body: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _editingController,
                        decoration: InputDecoration(
                          labelText: "Pesquise aqui",
                          prefixIcon: Icon(Icons.search),
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder()
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.left,
                        onSubmitted: (text){
                          _setSearch(text);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: FutureBuilder(
                  future: _getSearch(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 150.0,
                          height: 150.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            strokeWidth: 2.5,
                          ),
                        );
                      default:
                        if(snapshot.hasError) return Container();
                        else return _createListView(context, snapshot);
                    }
                  }
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _setSearch(_editingController.text);
          },
          child: Icon(Icons.search),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 2),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          if (_search != null && _search.trim() != ''){
            return InkWell(
              child: Card(
                child: Container(
                  height: 90,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          _normalizarTexto(snapshot.data[index].titulo),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          _normalizarURL(snapshot.data[index].url),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ResultPage(snapshot.data[index].url, snapshot.data[index].titulo);
                      },
                    ),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }

  void _setSearch(String text) {
    if (text.trim() != '') {
      setState(() {
        _search = text.trim();
      });
    }
  }

  String _normalizarTexto(String text){
    const comprimentroCard = 42;
    if (text.length > comprimentroCard){
      text = text.substring(0, comprimentroCard) + '...';
    }
    return text;
  }

  String _normalizarURL(String text){
    const comprimentroCard = 70;
    if (text.length > comprimentroCard){
      text = text.substring(0, comprimentroCard) + '...';
    }
    return text;
  }
}
