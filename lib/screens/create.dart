import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apiorc/env.dart';
import 'package:apiorc/widget/form.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart';

class Create extends StatefulWidget {
  final Function? refreshOrcamentoList;

  Create({this.refreshOrcamentoList});

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  // Required for form validations
  final formKey = GlobalKey<FormState>();

  // Handles text onchange
  TextEditingController nameController = new TextEditingController();
  TextEditingController detailController = new TextEditingController();
  String status = '';
  //String errMessage = 'Error Uploading Image';
  //final picker = ImagePicker();
  //File? _image;


  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

/*
  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });

  }
*/
  // Http post request to create new data

  Future _createOrcamento() async {
    final headers = {"Content-type": "application/json"};

    final url = Uri.parse('${Env.urlPrefix}/orcamentos');
    print(url);


    final json = '{"name": "${nameController.text}", "detail": "${detailController.text}"}';
    print(json);
    final response = await post(url, headers: headers, body: json);
    print('Codigo do status: ${response.statusCode}');
    print('Corpo: ${response.body}');


  }

  void _onConfirm(context) async {
    await _createOrcamento();

    // Remove all existing routes until the Home.dart, then rebuild Home.
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Criar"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: RaisedButton(
            child: Text("CONFIRMAR"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _onConfirm(context);
              }
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: AppForm(
                  formKey: formKey,
                  nameController: nameController,
                  detailController: detailController,
                ),
              ),
            ),

/*
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                getImage();
              },
            ),
            Container(
              child: _image == null ? Text('Nenhuma Imagem selecionada') : Image.file(_image!),
            ),

            SizedBox(
              height: 20.0,
            ),
            //showImage(),
            SizedBox(
              height: 20.0,
            ),
  */
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        )
    );
  }

}