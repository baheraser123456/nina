import 'package:fina/tools/deligate.dart';
import 'package:flutter/material.dart';

class editdelis extends StatelessWidget {
  const editdelis({super.key});
  static const name = 'editeditdeli';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context);
                showSearch(context: context, delegate: datafilterss());
              })),
    );
  }
}
