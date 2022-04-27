// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_dictionary_app/homepage/homepage-items.dart';
import 'package:flutter_dictionary_app/homepage/homepage.dart';
import 'package:flutter_dictionary_app/modules/dbHelper.dart';
import 'package:flutter_dictionary_app/modules/dictionary.dart';
import 'package:flutter_dictionary_app/word/word_details.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeHeader extends StatefulWidget {
  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final TextEditingController _searchingTextController =
      TextEditingController();
  DBHelper? _helper;

  var items = [];
  String keywords = "";

  @override
  void initState() {
    super.initState();
    _helper = DBHelper();
    _helper!.copyDB();
    //_listDict = <Dictionary>[];
    _helper!.getDictionary().then((value) {
      setState(() {
        items = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Column(children: [
      Container(
        height: 160,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF5F72BE), Color(0xFF9921E8)])),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text('Cat Dictionary'),
            ),
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                height: 40,
                alignment: Alignment.bottomCenter,
                child: TypeAheadField<Dictionary>(
                    debounceDuration: Duration(milliseconds: 500),
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 12),
                          hintText: "Enter ",
                          prefixIcon: const Icon(Icons.search)),
                    ),
                    suggestionsCallback: _helper!.getSearchingWord,
                    itemBuilder: (context, Dictionary? dicts) {
                      final word = dicts!;
                      return ListTile(
                        title: Text(word.word),
                      );
                    },
                    onSuggestionSelected: (Dictionary? dicts) {
                      final dictionary = dicts!;
                      Navigator.pushNamed(context, WordDetails.routeName,
                          arguments: GetDetailFromList(dicts: dictionary));
                    }),
              ),
            ),
            // FutureBuilder(
            //   future: _helper!.getSearchingWord(keywords),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       print('error');
            //     }
            //     var data = snapshot.data;
            //     return snapshot.hasData
            //         ? DictionaryList(dicts: data as List<Dictionary>)
            //         : Container();
            //   },
            // )
          ],
        ),
      ),
    ]);
  }
}

class DictionaryList extends StatelessWidget {
  List<Dictionary> dicts;
  DictionaryList({required this.dicts});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: dicts.length,
          itemBuilder: (context, index) {
            return ListBody(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, WordDetails.routeName,
                        arguments: GetDetailFromList(dicts: dicts[index]));
                  },
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Text(
                            '${dicts[index].word}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text('${dicts[index].description}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
