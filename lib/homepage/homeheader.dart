// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, unnecessary_string_interpolations


import 'package:flutter/material.dart';
import 'package:flutter_dictionary_app/dbHelper/dbHelper.dart';
import 'package:flutter_dictionary_app/dbHelper/moor_database.dart';
import 'package:flutter_dictionary_app/word/word_av_details.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeHeader extends StatefulWidget {
  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  DBHelper? _helper;
  //List<Dictionary> historySearch = [];
  var items = [];
  String keywords = "";
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    _helper = DBHelper();
    _helper!.copyDB();
  }

  // _addSearchingWordToHistory(Dictionary words) async {
  //   prefs = await SharedPreferences.getInstance();
  //   Map<String, dynamic> decodeOptions = jsonDecode(words.toString());
  //   String user = jsonEncode(Dictionary.fromJson(decodeOptions));
  //   prefs!.setString('dicts', user);
  // }

  // _getHistorySearching() async {
  //   prefs = await SharedPreferences.getInstance();
  //   Map<String, dynamic> decodeOptions =
  //       jsonDecode(prefs!.getString('dicts') as String);
  //   var word = Dictionary.fromJson(decodeOptions);
  //   historySearch.add(word);
  //   return historySearch;
  // }

  @override
  Widget build(BuildContext context) {
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
                child: _buildSearchBar(context)
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
_buildSearchBar(BuildContext context) {
  final dao = Provider.of<DictionaryDao>(context);
  return TypeAheadField<AVData>(
      debounceDuration: const Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(top: 12),
            hintText: "Enter ",
            prefixIcon: const Icon(Icons.search)),
      ),
      suggestionsCallback: dao.getFilteredItemsAV,
      itemBuilder: (context, AVData? dicts) {
        final getWord = dicts!;
        return Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Text(
                    '${getWord.word}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text('${getWord.description}'),
                ],
              ),
            ));
      },
      onSuggestionSelected: (AVData? dicts) {
      });
}
class DictionaryList extends StatelessWidget {
  List<AVData> dicts;
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
                    Navigator.pushNamed(context, WordAVDetails.routeName,
                        arguments: GetAVDetailFromList(av: dicts[index]));
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
