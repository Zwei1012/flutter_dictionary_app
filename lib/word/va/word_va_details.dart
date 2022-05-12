// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, iterable_contains_unrelated_type

import 'package:flutter/material.dart';
import 'package:flutter_dictionary_app/dbHelper/moor_database.dart';
import 'package:flutter_dictionary_app/modules/favourite-data.dart';
import 'package:flutter_dictionary_app/translateVA/translate_va.dart';
import 'package:flutter_dictionary_app/word/va/body.dart';

class WordVADetails extends StatefulWidget {
  static String routeName = '/wordVA';

  @override
  State<WordVADetails> createState() => _WordVADetailssState();
}

class _WordVADetailssState extends State<WordVADetails> {
  @override
  Widget build(BuildContext context) {
    final GetVA dataVA = ModalRoute.of(context)!.settings.arguments as GetVA;
    bool isSaved = Favourite.dataVADict.contains(dataVA.va);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 5,
          title: Text(
            dataVA.va.word,
            style: const TextStyle(fontSize: 23.1, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                bool isSavedHistory = VAData.historyVA.contains(dataVA.va);
                return setState(() {
                  if (!isSavedHistory) {
                    VAData.historyVA.add(dataVA.va);
                  }
                });
              },
              icon: const Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (!isSaved) {
                    Favourite.dataVADict.add(dataVA.va);
                  }
                });
              },
              icon: Icon(
                isSaved ? Icons.star : Icons.star_border_outlined,
                color: isSaved ? Colors.yellow : null,
              ),
            )
          ],
          flexibleSpace: Container(
            padding: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5F72BE), Color(0xFF9921E8)])),
          ),
        ),
        body: Body(vaData: dataVA.va));
  }
}

class GetVA {
  VAData va;
  GetVA({required this.va});
}
