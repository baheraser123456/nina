import 'package:fina/tools/button.dart';
import 'package:fina/tools/txtfiled.dart';

import 'package:flutter/material.dart';

class idser extends StatelessWidget {
  idser({super.key});
  String? id;
  static const String name = 'idser';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              custfiled(
                hint: 'الكود',
                onsaved: (data) {
                  id = data;
                },
              ),
              custbutton(
                hint: 'بحث',
                fun: () {},
              )
            ],
          ),
        ));
  }
}
