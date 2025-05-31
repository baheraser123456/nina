import 'package:fina/constants.dart';
import 'package:fina/html-bob.dart';
import 'package:fina/tools/button.dart';
import 'package:fina/tools/excel.dart';

import 'package:flutter/material.dart';

class ChMonth2024 extends StatelessWidget {
  const ChMonth2024({super.key});
  static const name = 'chMounth2024';
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
              fun: () async {
                String mon = (index + 1).toString();
                var res = await post(mch2024, {'ip': mon});

                createExcel(res['data'], index + 1);
              },
            ),
          );
        },
        itemCount: 12,
      ),
    );
  }
}
