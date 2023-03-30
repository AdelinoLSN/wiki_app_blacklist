import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        Iterable list = jsonDecode(response.body);
        _sentences = list.map((model) => model).toList();
      });
    } else {
      print('Erro ao carregar as sentenças');
    }
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
            child: Column(children: [
              const Text('Lista de sentenças'),
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
                        title: Text(_sentences[index]['text']),
                      );
                    }
                  }
                },
              ),
            ]),
          ),
        ));
  }
}
