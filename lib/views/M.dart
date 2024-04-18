import 'package:fina/tools/button.dart';
import 'package:fina/views/cardsdeli.dart';
import 'package:flutter/material.dart';

class Month extends StatelessWidget {
  const Month({super.key});
  static const name = 'Mounth';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            child: custbutton(
              hint: 'شهر ${index + 1}',
              fun: () {
                showSearch(
                  context: context,
                  delegate: cardsdeli(gg: index + 1),
                );
              },
            ),
          );
        },
        itemCount: 12,
      ),
    );
  }
}
