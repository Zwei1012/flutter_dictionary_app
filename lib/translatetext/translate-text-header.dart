// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class TranslateHeader extends StatefulWidget {

  @override
  State<TranslateHeader> createState() => _TranslatetextState();
}

class _TranslatetextState extends State<TranslateHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5F72BE), Color(0xFF9921E8)])),
          child: Column(
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: const Text('Translate text'),
              ),
            ],
          ),
    );
  }
}