import 'package:cubit_form/cubit_form.dart';

import 'package:fina/cubit/nodata_cubit.dart';

import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/tools/button.dart';

import 'package:fina/views/posprinting.dart';

import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class pos extends StatefulWidget {
  const pos({super.key});
  static const name = 'pos';

  @override
  State<pos> createState() => _hhhState();
}

class _hhhState extends State<pos> {
  bool hh = false;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> GG = GlobalKey();
    String name = ModalRoute.of(context)!.settings.arguments as String;
    BlocProvider.of<DatacubitCubit>(context).getcard(name);
    return BlocBuilder<DatacubitCubit, DatacubitState>(
      builder: (context, state) => state is Datacubitsuc
          ? Scaffold(
              appBar: AppBar(
                title: const Text("توزيع"),
              ),
              body: BlocListener<NodataCubit, NodataState>(
                listener: (context, state) {
                  if (state is Nodataloading) {
                    hh = true;
                    setState(() {});
                  } else if (state is Nodatasuc) {
                    Navigator.popAndPushNamed(context, posorinting.name,
                        arguments: state.hh);
                    hh = false;
                    setState(() {});
                  } else if (state is Nodatafail) {
                    hh = false;
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            ' هناك خطأ في الاتصال بالشبكة حاول مرة اخري')));
                  }
                },
                child: ModalProgressHUD(
                  inAsyncCall: hh,
                  child: Form(
                    key: GG,
                    child: Center(
                      child: Column(
                        children: [
                          _createDataTable(
                            context: context,
                            A: state.data['data'][0]['id'],
                            B: state.data['data'][0]['name'],
                            E: state.data['data'][0]['real'],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          custbutton(
                            hint: '${state.data['data'][0]['real'] * 5}',
                            fun: () {
                              BlocProvider.of<NodataCubit>(context).pos(
                                  state.data['data'][0]['name'],
                                  (state.data['data'][0]['real'] * 5),
                                  state.data['data'][0]['place']);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ))
          : Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('هناك خطأ في الشبكة'),
              ),
            ),
    );
  }
}

DataTable _createDataTable({
  required BuildContext context,
  required A,
  required B,
  required E,
}) {
  return DataTable(
      columns: _createColumns(),
      rows: _createRows(
        context: context,
        A: A,
        B: B,
        E: E,
      ));
}

List<DataColumn> _createColumns() {
  return [
    const DataColumn(label: Text('الكود')),
    const DataColumn(label: Text(' صاحب البطاقة')),
    const DataColumn(label: Text('عدد الأفراد')),
  ];
}

List<DataRow> _createRows({
  required BuildContext context,
  required A,
  required B,
  required E,
}) {
  return [
    DataRow(cells: [
      DataCell(Text(A.toString())),
      DataCell(Text(B)),
      DataCell(Text(E.toString())),
    ]),
  ];
}
