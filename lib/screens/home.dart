import 'dart:io';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:apiorc/network/api.dart';
import 'login.dart';

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
  String name='';

  late Future<List<Orcamento>> orcamentos;
  final orcamentoListKey = GlobalKey<HomeState>();
  final url = Uri.parse("${Env.urlPrefix}/orcamentos");

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    //var user = jsonDecode(localStorage.getString('user'));

    if(user != null) {
      setState(() {
        name = user['name'];
        orcamentos = getOrcamentoList();
      });
    }
  }


  Future<List<Orcamento>> getOrcamentoList() async {


    //Buscar na memória do dispositivo a variavel contendo o Token
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenJson = localStorage.getString('token');
    var token = json.decode(tokenJson!)['token'];
    //print(token);

    //Passar o token para o laravel pelo Header
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };




    //acessar URL para pegar a lista de itens
    final response = await http.get(url, headers: headers);

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
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: (){
              logout();
            },
          )
        ],
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
                              backgroundImage: NetworkImage("${Env.urlHost}/images/${data.image}"),
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


  //Fazer Logout
  void logout() async{
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }
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