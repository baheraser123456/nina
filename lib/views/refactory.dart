import 'package:cubit_form/cubit_form.dart';
import 'package:fina/getcubit/get_cubit.dart';

import 'package:flutter/material.dart';

class refactor extends StatelessWidget {
  const refactor({super.key});
  static String name = 'refactor';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: const Text('هل انت متأكد من اعادة ضبط المصنع؟'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لا'),
                ),
                TextButton(
                  onPressed: () {
                    Future.delayed(const Duration(seconds: 1), () {
                      BlocProvider.of<GetCubit>(context).resets();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم اعادة ضبط المصنع')));

                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    });
                  },
                  child: const Text('نعم'),
                ),
              ],
            ),
          ),
          child: const Text('اعادة ضبط المصنع'),
        ),
      ),
    );
  }
}
