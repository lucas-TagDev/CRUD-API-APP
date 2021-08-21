import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:apiorc/env.dart';
import 'package:apiorc/model/orcamento.dart';
import 'package:http/http.dart';
import './edit.dart';

class Details extends StatefulWidget {
  final Orcamento? orcamento;

  Details({this.orcamento});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  void deleteOrcamento(context) async {

    //deletar item aqui
    final url = Uri.parse('${Env.urlPrefix}/orcamentos/${widget.orcamento?.id.toString()}');
    final response = await http.delete(url);
    print('Codigo do status: ${response.statusCode}');
    print('Corpo: ${response.body}');


    // Navigator.pop(context);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('deseja realemnte deletar isso?'),
          actions: <Widget>[
            RaisedButton(
              child: Icon(Icons.cancel),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            RaisedButton(
              child: Icon(Icons.check_circle),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => deleteOrcamento(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => confirmDelete(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 270.0,
            padding: const EdgeInsets.all(35),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nome : ${widget.orcamento?.name}",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text(
                  "Detalhe: ${widget.orcamento?.detail}",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Edit(orcamento: widget.orcamento),
          ),
        ),
      ),
    );
  }
}