import 'package:fina/constants.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/html.dart';

import 'package:fina/tools/button.dart';
import 'package:fina/tools/txtfiled.dart';

import 'package:fina/views/printing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class blockpage extends StatefulWidget {
  const blockpage({super.key});
  static const name = 'blck';

  @override
  State<blockpage> createState() => _hhhState();
}

class _hhhState extends State<blockpage> {
  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)!.settings.arguments as String;
    String? res;
    int? now;
    GlobalKey<FormState> GG = GlobalKey();

    BlocProvider.of<DatacubitCubit>(context).getdata(name);
    return BlocConsumer<DatacubitCubit, DatacubitState>(
      builder: (context, state) => state is Datacubitsuc
          ? state.data['data'][0]['stutas'] == 'true'
              ? Form(
                  key: GG,
                  child: Scaffold(
                      appBar: AppBar(
                        title: const Text('البيانات'),
                      ),
                      body: ListView(children: [
                        _createDataTable(
                            context: context,
                            B: state.data['data'][0]['name'],
                            A: state.data['data'][0]['id'],
                            C: state.data['data'][0]['number'],
                            E: state.data['data'][0]['numbers'],
                            F: state.data['data'][0]['last'],
                            G: state.data['data'][0]['date']),
                        const SizedBox(
                          height: 70,
                        ),
                        custfiled(
                          hh: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[ا-ي ,ئ,ء,ؤ,أ]'))
                          ],
                          onsaved: (data) {
                            res = data;
                          },
                          hint: 'سبب الحظر',
                          val: (data) {
                            if (data!.isEmpty) {
                              return 'حقل مطلوب';
                            }
                            return null;
                          },
                        ),
                        custbutton(
                          hint: 'حظر',
                          fun: () {
                            if (GG.currentState!.validate()) {
                              var respon = post(block, {
                                'name': state.data['data'][0]['name'],
                                'stutas': 'false',
                                'date': DateTime.now().toString(),
                                'pro': 'block',
                                'res': res
                              });
                              if (respon == 'wrong') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'العملية لم تتم حاول مرة اخري')));
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          },
                        )
                      ])),
                )
              : Form(
                  key: GG,
                  child: Scaffold(
                      appBar: AppBar(
                        title: const Text('البيانات'),
                      ),
                      body: ListView(children: [
                        _createDataTable(
                            context: context,
                            B: state.data['data'][0]['name'],
                            A: state.data['data'][0]['id'],
                            C: state.data['data'][0]['number'],
                            E: state.data['data'][0]['numbers'],
                            F: state.data['data'][0]['last'],
                            G: state.data['data'][0]['date']),
                        const SizedBox(
                          height: 70,
                        ),
                        custbutton(
                          hint: 'فك الحظر',
                          fun: () {
                            var respone = post(block, {
                              'name': state.data['data'][0]['name'],
                              'stutas': 'true',
                              'date': DateTime.now().toString(),
                              'pro': 'unblock',
                              'res': ""
                            });
                            if (respone == 'wrong') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'العملية لم تتم حاول مرة اخري')));
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        )
                      ])),
                )
          : state is Datacubitloading
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : state is Datacubitfail
                  ? Scaffold(
                      appBar: AppBar(),
                      body: const Center(
                        child: Text('هناك خطا في الشبكة'),
                      ),
                    )
                  : Scaffold(
                      appBar: AppBar(),
                      body: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
      listener: (BuildContext context, DatacubitState state) {
        if (state is Datacubitsuc) {
          BlocProvider.of<DatacubitCubit>(context).hh = [
            state.data['data'][0]['name'],
            state.data['data'][0]['id'].toString(),
          ];
        }
        if (state is Datacubitsucs) {
          BlocProvider.of<DatacubitCubit>(context).hh.insert(1, now.toString());
          BlocProvider.of<DatacubitCubit>(context).hh.insert(2, state.zz);
          BlocProvider.of<DatacubitCubit>(context)
              .hh
              .add(state.data['data'][0]['id']);

          Navigator.popAndPushNamed(context, Printing.name,
              arguments: BlocProvider.of<DatacubitCubit>(context).hh);
        }
      },
    );
  }

  DataTable _createDataTable(
      {required BuildContext context,
      required A,
      required B,
      required C,
      required E,
      required F,
      required G}) {
    return DataTable(
        columns: _createColumns(),
        rows:
            _createRows(context: context, A: A, B: B, C: C, E: E, F: F, G: G));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('الكود')),
      const DataColumn(label: Text(' صاحب البطاقة')),
      const DataColumn(label: Text('عدد الأرغفة')),
      const DataColumn(label: Text('عدد الأفراد')),
      const DataColumn(label: Text('اخر سحب')),
      const DataColumn(label: Text('تاريخ '))
    ];
  }

  List<DataRow> _createRows(
      {required BuildContext context,
      required A,
      required B,
      required C,
      required E,
      required F,
      required G}) {
    return [
      DataRow(cells: [
        DataCell(Text(A.toString())),
        DataCell(Text(B)),
        DataCell(Text(C.toString())),
        DataCell(Text(E.toString())),
        DataCell(Text(F.toString())),
        DataCell(Text(G.toString())),
      ]),
    ];
  }
}
