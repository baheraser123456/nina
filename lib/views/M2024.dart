import 'package:fina/tools/button.dart';
import 'package:fina/views/cd.dart';
import 'package:flutter/material.dart';

class Month2024 extends StatelessWidget {
  const Month2024({super.key});
  static const name = 'Mounth2024';
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
                  delegate: cardsdelis(gg: index + 1),
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
