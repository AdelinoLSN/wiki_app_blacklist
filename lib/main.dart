import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  const url = "http://10.0.2.2:8080/blacklist/sentence";

  Map<String, String> headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'text': sentence});

  final response =
      await http.post(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Sentença adicionada com sucesso!');
    print(response.body);
    return response;
  } else {
    throw Exception('Falha ao adicionar sentença');
  }
}
