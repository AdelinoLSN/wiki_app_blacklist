import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Gestor: Blacklist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormAddSentence(),
    );
  }
}

class FormAddSentence extends StatefulWidget {
  const FormAddSentence({super.key});

  @override
  State<FormAddSentence> createState() => _FormAddSentenceState();
}

class _FormAddSentenceState extends State<FormAddSentence> {
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  void _submitForm() async {
    setState(() {
      _isButtonDisabled = true;
    });

    await createSentence('teste');

    setState(() {
      _isButtonDisabled = false;
    });
  }

  // void _submitForm() {
  //   setState(() {
  //     _isButtonDisabled = true;
  //   });

  //   // show a snackbar
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Adicionando sentença...'),
  //     ),
  //   );

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Sentença adicionada com sucesso!'),
  //     ),
  //   );

  //   setState(() {
  //     _isButtonDisabled = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wiki Gestor: Blacklist'),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Sentença',
                ),
              ),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: _isButtonDisabled ? null : _submitForm,
        child: const Text('Adicionar'),
      ),
    );
  }
}

Future<http.Response> createSentence(String sentence) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    print('Sentença adicionada com sucesso!');
    print(response.body);
    return response;
  } else {
    throw Exception('Falha ao adicionar sentença');
  }
}
