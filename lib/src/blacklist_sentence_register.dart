import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseUrl = 'http://10.0.2.2:8080';

class BlacklistSentenceRegister extends StatelessWidget {
  const BlacklistSentenceRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return FormAddSentence();
  }
}

class FormAddSentence extends StatefulWidget {
  const FormAddSentence({super.key});

  @override
  State<FormAddSentence> createState() => _FormAddSentenceState();
}

class _FormAddSentenceState extends State<FormAddSentence> {
  final _textFieldController = TextEditingController();

  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  Future<http.Response> createSentence(String sentence) async {
    const url = "$baseUrl/blacklist/sentence";

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'text': sentence});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    return response;
  }

  void _submitForm() async {
    setState(() {
      _isButtonDisabled = true;
    });

    var sentence = _textFieldController.text;

    final response = await createSentence(sentence);

    if (response.statusCode == 200) {
      print('Sentença adicionada com sucesso!');
      print(response.body);
      _textFieldController.clear();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Sentença adicionada com sucesso!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print('Erro ao adicionar sentença!');
      print(response.body);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Falha ao adicionar sentença!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Wiki Gestor: Blacklist'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _textFieldController,
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
