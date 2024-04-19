import 'package:fina/constants.dart';
import 'package:fina/html.dart';
import 'package:fina/tools/button.dart';
import 'package:flutter/material.dart';

class EditAll extends StatelessWidget {
  const EditAll({super.key});
  static const name = 'editall';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(top: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  custbutton(
                    hint: '-5',
                    fun: () async {
                      var res = await post(edidall, {'number': '-5'});
                      if (res == 'wrong') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('العملية لم تتم بنجاح')));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  custbutton(
                    hint: '+5',
                    fun: () async {
                      var res = await post(edidall, {'number': '5'});
                      if (res == 'wrong') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('العملية لم تتم بنجاح')));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        custbutton(
          hint: '-10',
          fun: () async {
            var res = await post(edidall, {'number': '-10'});
            if (res == 'wrong') {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('العملية لم تتم بنجاح')));
            } else {
              Navigator.pop(context);
            }
          },
        )
      ]),
    );
  }
}
