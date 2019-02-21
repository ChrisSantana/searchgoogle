import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ResultPage extends StatefulWidget {
  final String _url;
  final String _title;

  ResultPage(this._url, this._title);

  @override
  _ResultPageState createState() => _ResultPageState(_url, _title);
}

class _ResultPageState extends State<ResultPage> {
  final _urlLogo = 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png';
  final String _url;
  final String _title;

  _ResultPageState(this._url, this._title);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: _url.trim(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[300],
          title: _title.trim() == _urlLogo ?
            Image.network(
              _title,
              fit: BoxFit.fill,
            ) :
            Text(
              _title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          centerTitle: true,
        ),
        initialChild: Center(
          child: CircularProgressIndicator(),
        )
    );
  }
}

/*title: Image.network(
  _urlLogo,
  fit: BoxFit.fill,
),*/

