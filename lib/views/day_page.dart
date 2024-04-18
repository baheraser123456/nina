import 'package:cubit_form/cubit_form.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/html.dart';
import 'package:fina/tools/button.dart';
import 'package:fina/views/printing.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class daypage extends StatelessWidget {
  const daypage({super.key});
  static const name = 'daypage';
  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)!.settings.arguments as String;

    int? now;
    GlobalKey<FormState> GG = GlobalKey();

    BlocProvider.of<DatacubitCubit>(context).getdata(name);
    return BlocConsumer<DatacubitCubit, DatacubitState>(
      builder: (context, state) => state is Datacubitsuc
          ? state.data['data'][0]['day'] == 'غير'
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
                        custbutton(
                          hint: 'تفعيل الصرف اليومي',
                          fun: () {
                            post(day, {
                              'ip': state.data['data'][0]['id'].toString(),
                              'name': state.data['data'][0]['name'],
                              'per': 'يومي',
                              'date': DateTime.now().toString(),
                              'pro': "تفعيل الصرف اليومي"
                            });
                            Navigator.pop(context);
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
                          hint: ' تعطيل الصرف اليومي',
                          fun: () {
                            post(day, {
                              'ip': state.data['data'][0]['id'].toString(),
                              'name': state.data['data'][0]['name'],
                              'per': 'غير',
                              'date': DateTime.now().toString(),
                              'pro': 'تعطيل الصرف اليومي'
                            });
                            Navigator.pop(context);
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
