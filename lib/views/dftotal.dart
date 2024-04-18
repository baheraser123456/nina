import 'package:cubit_form/cubit_form.dart';

import 'package:fina/cubit3/total_cubit.dart';
import 'package:flutter/material.dart';

class dfTotal extends StatefulWidget {
  const dfTotal({super.key});
  static String name = 'dftotal';

  @override
  State<dfTotal> createState() => _TotalState();
}

class _TotalState extends State<dfTotal> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TotalCubit>(context).gettotal();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalCubit, TotalState>(
      builder: (context, state) {
        if (state is Totalsuc) {
          return Scaffold(
              appBar: AppBar(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _createDataTables(
                      context: context, A: ' عدد الأرغفة', day: 'اليوم'),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 31,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: _createDataTable(
                                context: context,
                                A: state.data['data'][index]['last'].toString(),
                                day: (index + 1).toString()),
                          );
                        }),
                  ),
                ],
              ));
        } else if (state is Totalload) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('هناك خطا'),
            ),
          );
        }
      },
    );
  }

  DataTable _createDataTable(
      {required BuildContext context, required String A, required day}) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(
          day: day,
          context: context,
          A: A,
        ));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('')),
      const DataColumn(label: Text('')),
    ];
  }

  List<DataRow> _createRows(
      {required BuildContext context, required A, required day}) {
    return [
      DataRow(cells: [
        DataCell(Text(A.toString())),
        DataCell(Text(day)),
      ]),
    ];
  }

  DataTable _createDataTables(
      {required BuildContext context, required String A, required day}) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(
          day: day,
          context: context,
          A: A,
        ));
  }

  List<DataColumn> _createColumnss() {
    return [
      const DataColumn(label: Text('')),
      const DataColumn(label: Text('')),
    ];
  }

  List<DataRow> _createRowss(
      {required BuildContext context, required A, required day}) {
    return [
      DataRow(cells: [
        DataCell(Text(A.toString())),
        DataCell(Text(day)),
      ]),
    ];
  }
}
