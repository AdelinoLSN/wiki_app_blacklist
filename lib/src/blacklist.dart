import 'package:flutter/material.dart';

import './blacklist_sentence_list.dart';
import './blacklist_sentence_register.dart';

class Blacklist extends StatelessWidget {
  const Blacklist({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Gestor: Blacklist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlacklistHome(),
    );
  }
}

class BlacklistHome extends StatelessWidget {
  const BlacklistHome({super.key});

  // A menu with options to list or register sentences
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wiki Gestor: Blacklist'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlacklistSentenceList(),
                  ),
                );
              },
              child: const Text('Listar Sentenças'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlacklistSentenceRegister(),
                  ),
                );
              },
              child: const Text('Cadastrar Sentenças'),
            ),
          ],
        ),
      ),
    );
  }
}
