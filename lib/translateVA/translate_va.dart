// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, unused_field, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, must_be_immutable, avoid_print


import 'package:flutter/material.dart';
import 'package:flutter_dictionary_app/dbHelper/moor_database.dart';
import 'package:flutter_dictionary_app/word/va/word_va_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslateVA extends StatefulWidget {
  static String routeName = '/vadicts';
  @override
  State<TranslateVA> createState() => _TranslateVAState();
}

class _TranslateVAState extends State<TranslateVA> {
  SharedPreferences? prefs;
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  final TextEditingController _searchingTextController =
      TextEditingController();
  String keywords = "search";

  @override
  Widget build(BuildContext context) {
    final dao = Provider.of<DictionaryDao>(context);
  Future<List<VAData>> _getSearchData(String name) async {
      final historyWords = await dao.historyWordVA();
      for (var element in historyWords) {
        final e = element.word.toLowerCase();
        final queryWord = name.toLowerCase();
        if (e.contains(queryWord)) {
          return historyWords.where((element) {
            return e.contains(queryWord);
          }).toList();
        }
      }
      return dao.getFilteredItemsVA(name);
    }
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: const Text("Viet - Eng Dictionary"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5F72BE), Color(0xFF9921E8)])),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchingTextController,
              onChanged: (value) {
                keywords = value;
                setState(() {
                  //_listDict = _helper!.getSearchingWord(value) as List;
                });
              },
              decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
            ),
          ),
          FutureBuilder(
            future: _getSearchData(keywords),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('error');
              }
              var data = snapshot.data;
              return snapshot.hasData &&
                      _searchingTextController.text.isNotEmpty
                  ? DictionaryList(dicts: data as List<VAData>)
                  : Container();
            },
          )
        ],
      ),
    );
  }
}

class DictionaryList extends StatefulWidget {
  List<VAData> dicts;
  DictionaryList({required this.dicts});

  @override
  State<DictionaryList> createState() => _DictionaryListState();
}

class _DictionaryListState extends State<DictionaryList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.dicts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                
                Navigator.pushNamed(context, WordVADetails.routeName,
                    arguments: GetVA(va: widget.dicts[index]));
              },
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.dicts[index].word}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text('${widget.dicts[index].description}'),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
