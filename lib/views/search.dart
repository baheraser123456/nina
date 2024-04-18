import 'package:fina/views/deli.dart';

import 'package:flutter/material.dart';

class searchedit extends StatelessWidget {
  const searchedit({super.key});
  static const name = '  تعديل الأفراد';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          GestureDetector(
              child:
                  const Text('البحث بالاسم', textDirection: TextDirection.rtl),
              onTap: () {
                Navigator.pop(context);
                showSearch(
                  context: context,
                  delegate: datafilter(),
                );
              }),
          const Spacer(
            flex: 1,
          )
        ],
      )),
    );
  }
}
