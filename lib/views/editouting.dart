import 'package:cubit_form/cubit_form.dart';
import 'package:fina/constants.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/html.dart';
import 'package:fina/tools/txtfiled.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class lastouting extends StatefulWidget {
  const lastouting({super.key});
  static const name = 'editlastout';

  @override
  State<lastouting> createState() => _lastoutingState();
}

num? now;

class _lastoutingState extends State<lastouting> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DatacubitCubit>(context).getlast();
    return BlocBuilder<DatacubitCubit, DatacubitState>(
      builder: (BuildContext context, state) => state is Datacubitsuc
          ? Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  custfiled(
                    hh: [FilteringTextInputFormatter.digitsOnly],
                    onfiledsubmited: (value) async {
                      now = int.parse(value);
                      await post(editlastout, {
                        'outing': (0 - now!).toString(),
                        'last': value,
                        'total': DateTime.now().day.toString(),
                        'date': DateTime.now().toString(),
                        'pro': (0 - now!).toString()
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          : Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

DataTable _createDataTable({required BuildContext context, required A}) {
  return DataTable(
      columns: _createColumns(), rows: _createRows(context: context, A: A));
}

List<DataColumn> _createColumns() {
  return [
    const DataColumn(label: Text('اخر خارجي')),
  ];
}

List<DataRow> _createRows({required BuildContext context, required A}) {
  return [
    DataRow(cells: [
      DataCell(Text(A.toString())),
    ]),
  ];
}
