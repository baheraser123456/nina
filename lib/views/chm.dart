import 'package:fina/tools/button.dart';
import 'package:fina/views/cardsdeli.dart';
import 'package:flutter/material.dart';

class ChMonth extends StatelessWidget {
  const ChMonth({super.key});
  static const name = 'chMounth';
  @override
  Widget build(BuildContext context) {
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
