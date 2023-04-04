import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './blacklist_sentence_register.dart';

const baseUrl = 'http://10.0.2.2:8080';

class BlacklistSentenceList extends StatelessWidget {
  const BlacklistSentenceList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Gestor: Blacklist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListSentence(),
    );
  }
}

class ListSentence extends StatefulWidget {
  const ListSentence({super.key});

  @override
  State<ListSentence> createState() => _ListSentenceState();
}

class _ListSentenceState extends State<ListSentence> {
  List<dynamic> _sentences = [];

  @override
  void initState() {
    super.initState();
    getSentences();
  }

  void getSentences() async {
    final response = await http.get(Uri.parse('$baseUrl/blacklist/sentence'));

    if (response.statusCode == 200) {
      setState(() {
        Iterable list = jsonDecode(response.body);
        _sentences = list.map((model) => model).toList();
      });
    } else {
      // Show error message
      print('Erro ao carregar lista de sentenças');
      print(response.body);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text("Não foi possível carregar a lista de sentenças"),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void openEditSentenceDialog(context, sentence) async {
    final _textEditingController = TextEditingController();

    _textEditingController.text = sentence['text'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar sentença'),
          content: TextField(
            controller: _textEditingController,
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                updateSentence(sentence['id'], _textEditingController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void updateSentence(sentenceId, editSentenceController) async {
    final url = '$baseUrl/blacklist/sentence/';

    Map<String, String> headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'id': sentenceId,
      'text': editSentenceController,
    });

    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Sentença atualizada com sucesso!');
      print(response.body);
      getSentences();
      Navigator.of(context).pop();
    } else {
      // Show error message
      print('Erro ao atualizar sentença');
      print(response.body);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text("Não foi possível atualizar a sentença"),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Wiki Gestor: Blacklist'),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {
                if (Navigator.canPop(context)) {Navigator.pop(context)}
              },
            )),
        body: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Lista de sentenças'),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      getSentences();
                    },
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _sentences.length,
                itemBuilder: (context, index) {
                  if (_sentences.isEmpty) {
                    return const Text('Nenhuma sentença encontrada');
                  } else {
                    if (_sentences[index] != null &&
                        _sentences[index]['text'] != null) {
                      return ListTile(
                        // Text and two buttons: edit and delete
                        title: Text(_sentences[index]['text']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => {
                                // Open a dialog to edit sentence
                                openEditSentenceDialog(
                                    context, _sentences[index])
                              },
                            )
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BlacklistSentenceRegister()),
            );
          },
          tooltip: 'Adicionar sentença',
          child: const Icon(Icons.add),
        ));
  }
}
