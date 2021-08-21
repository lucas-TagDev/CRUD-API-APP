import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apiorc/env.dart';
import 'package:apiorc/model/orcamento.dart';
import 'detalhes.dart';
import 'create.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List<Orcamento>> orcamentos;
  final orcamentoListKey = GlobalKey<HomeState>();
  final url = Uri.parse("${Env.urlPrefix}/orcamentos");

  @override
  void initState() {
    super.initState();
    orcamentos = getOrcamentoList();
  }

  Future<List<Orcamento>> getOrcamentoList() async {
    final response = await http.get(url);
    print(json.decode(response.body));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Orcamento> orcamentos = items.map<Orcamento>((json) {
      return Orcamento.fromJson(json);
    }).toList();
    return orcamentos;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: orcamentoListKey,
      appBar: AppBar(
        title: Text('Listar Orcamentos'),
      ),
      body: Center(
        child: FutureBuilder<List<Orcamento>>(
          future: orcamentos,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return CircularProgressIndicator();
            // Redereriza a lista de orcamentos
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return GestureDetector(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage("http://www.leblue.com.br/wp-content/uploads/2016/04/icon-quote.png"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              child: Text(data.name),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Details(orcamento: data)),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Create();
          }));
        },
      ),
    );
  }
}


/*

                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.view_list),
                    title: Text(
                      data.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Details(student: data)),
                      );
                    },
                  ),
*/