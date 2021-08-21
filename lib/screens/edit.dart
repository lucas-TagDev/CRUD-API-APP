import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:image_picker/image_picker.dart';

import 'package:apiorc/env.dart';
import 'package:apiorc/model/orcamento.dart';
import 'package:apiorc/widget/form.dart';
import 'package:http/http.dart';

class Edit extends StatefulWidget {
  final Orcamento? orcamento;

  Edit({this.orcamento});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();
  //final url = Uri.parse('${Env.urlPrefix}/orcamentos');

  //final picker = ImagePicker();
  //File? _image;

  // This is for text onChange
  TextEditingController? nameController;
  TextEditingController? detailController;

 /* Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });

  }
*/
  // Http post request
  //VAMOS ATUALIZAR NOSSO ORCAMENTO AQUI
  Future editOrcamento() async {

    final headers = {"Content-type": "application/json"};

    final url = Uri.parse('${Env.urlPrefix}/orcamentos/${widget.orcamento?.id.toString()}');
    print(url);

    final json = '{"name": "${nameController?.text}", "detail": "${detailController?.text}", "body": "body text", "id": ${widget.orcamento?.id.toString()}}';
    final response = await put(url, headers: headers, body: json);
    print('Codigo do status: ${response.statusCode}');
    print('Corpo: ${response.body}');


  }

  void _onConfirm(context) async {
    await editOrcamento();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    nameController = TextEditingController(text: widget.orcamento?.name);
    detailController = TextEditingController(text: widget.orcamento?.detail.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: RaisedButton(
            child: Text('CONFIRMA'),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              _onConfirm(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
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
              if(_image == null)
                Container(
                  width: 250.0,
                  height: 250.0,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network("http://demo06.vaipost.com/flutter_api/uploads/${widget.student?.image}"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),
              if(_image != null)
                Container(
                  width: 250.0,
                  height: 250.0,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(_image!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),

              TextButton(
                child: Text("MUDAR IMAGEM"),
                onPressed: () {
                  getImage();
                },
              ),
              */
            ],
          ),
        )
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('nameController', nameController));
  }
}