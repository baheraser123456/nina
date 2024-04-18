import 'package:fina/tools/datadatafilter.dart';
import 'package:flutter/material.dart';

class editdeli extends StatelessWidget {
  const editdeli({super.key});
  static const name = 'editdeli';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context);
                showSearch(context: context, delegate: datafilters());
              })),
    );
  }
}
