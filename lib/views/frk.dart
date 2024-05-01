import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/getcubit/get_cubit.dart';

import 'package:fina/views/frkprint.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../tools/button.dart';

class Frk extends StatefulWidget {
  const Frk({super.key});
  static const String name = 'frk';
  @override
  State<Frk> createState() => _Frk();
}

class _Frk extends State<Frk> {
  List hh = [];

  GlobalKey<FormState> GG = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String kk = ModalRoute.of(context)!.settings.arguments.toString();
    int ind = BlocProvider.of<GetCubit>(context)
        .frk
        .indexWhere((element) => element!.name == kk);
    String gg = BlocProvider.of<GetCubit>(context).frk[ind]!.id.toString();
    BlocProvider.of<DatacubitCubit>(context).getdatas(gg);

    return BlocConsumer<DatacubitCubit, DatacubitState>(
        listener: (context, state) {
      if (state is frksuc) {
        Navigator.popAndPushNamed(context, FrkPrinting.name, arguments: hh);
      }
    }, builder: (context, state) {
      if (state is Datacubitsuc) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('البيانات'),
            ),
            body: Form(
                key: GG,
                child: ListView(children: [
                  _createDataTable(
                      context: context,
                      A: state.data['data'][0]['name'].toString(),
                      B: state.data['data'][0]['SUM(number)'].toString(),
                      C: state.data['data'][0]['SUM(bk)'].toString()),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: custbutton(
                        hint: 'صرف',
                        fun: () {
                          if (state.data['data'][0]['SUM(number)'].toString() ==
                              '0') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('لا يوجد فرق عيش')));
                          } else {
                            hh = [
                              state.data['data'][0]['name'].toString(),
                              state.data['data'][0]['SUM(number)'].toString(),
                              state.data['data'][0]['SUM(bk)'].toString()
                            ];
                            BlocProvider.of<DatacubitCubit>(context).updatefrk(
                                gg,
                                state.data['data'][0]
                                    ['SUM(number)'.toString()]);
                          }
                        },
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                ])));
      } else if (state is Datacubitloading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('dsa')),
        );
      }
    });
  }

  DataTable _createDataTable(
      {required BuildContext context, required A, required B, required C}) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(context: context, A: A, B: B, C: C));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text(' صاحب البطاقة')),
      const DataColumn(label: Text("عدد الارغفة")),
      const DataColumn(label: Text("المبلغ المستحق"))
    ];
  }

  List<DataRow> _createRows(
      {required BuildContext context, required A, required B, required C}) {
    return [
      DataRow(cells: [
        DataCell(Text(A.toString())),
        DataCell(Text(B.toString())),
        DataCell(Text(C))
      ]),
    ];
  }
}
