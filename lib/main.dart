import 'package:flutter/material.dart';

import './screens/home.dart';
import './screens/create.dart';
import './screens/detalhes.dart';
import './screens/edit.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orcamento',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/create': (context) => Create(),
        '/details': (context) => Details(),
        '/edit': (context) => Edit(),
      },
    );
  }
}