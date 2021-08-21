import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class AppForm extends StatefulWidget {
  // Required for form validations
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  // Handles text onchange
  TextEditingController? nameController;
  TextEditingController? detailController;

  AppForm({this.formKey, this.nameController, this.detailController});

  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  String? _validateName(String? value) {
    if (value!.length < 3) return 'Nome precisa de pelo menos 2 caractere';
    return null;
  }

  String? _validateDetail(String? value) {
    if (value!.length < 3) return 'detalhe precisa de pelo menos 2 caractere';
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: widget.nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Nome'),
            validator: _validateName,
          ),
          TextFormField(
            controller: widget.detailController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Detalhe'),
            validator: _validateDetail,
          ),

        ],
      ),
    );;
  }
}