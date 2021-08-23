import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:apiorc/env.dart';
import 'package:apiorc/model/orcamento.dart';
import 'package:apiorc/widget/form.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final picker = ImagePicker();
  File? _image;

  // This is for text onChange
  TextEditingController? nameController;
  TextEditingController? detailController;


  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });

  }

  // Http post request
  //VAMOS ATUALIZAR NOSSO ORCAMENTO AQUI
  Future editOrcamento() async {
    //Buscar na memória do dispositivo a variavel contendo o Token
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenJson = localStorage.getString('token');
    var token = json.decode(tokenJson!)['token'];

    final headers = {"Content-type": "application/json", "Authorization": "Bearer $token"};

    final url = Uri.parse('${Env.urlPrefix}/orcamentos');
    print(url);

    var request = http.MultipartRequest('POST', url);
    //HEADERS
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    //CAMPOS
    request.fields['id'] = '${widget.orcamento?.id.toString()}';
    request.fields['name'] = '${nameController?.text}';
    request.fields['detail'] = '${detailController?.text}';
    if(_image == null){
      request.fields['image'] = '';
    }else{
      var pic = await http.MultipartFile.fromPath("image", _image!.path);
      request.files.add(pic);
    }

    var response = await request.send();


  }

  void _onConfirm(context) async {
    await editOrcamento();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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

              if(_image == null)
                Container(
                  width: 250.0,
                  height: 250.0,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network("${Env.urlHost}/images/${widget.orcamento?.image}"),
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