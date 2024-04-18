import 'package:cubit_form/cubit_form.dart';

import 'package:fina/cubit/nodata_cubit.dart';

import 'package:fina/tools/button.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:fina/views/nonamedprinting.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class hhhh extends StatefulWidget {
  const hhhh({super.key});
  static const name = 'hhhh';

  @override
  State<hhhh> createState() => _hhhState();
}

class _hhhState extends State<hhhh> {
  int? now;
  bool hh = false;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> GG = GlobalKey();
    TextEditingController pp = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('بدون اسم'),
        ),
        body: BlocListener<NodataCubit, NodataState>(
          listener: (context, state) {
            if (state is Nodataloading) {
              hh = true;
              setState(() {});
            } else if (state is Nodatasuc) {
              Navigator.pushNamed(context, NoNamePrinting.name,
                  arguments: state.hh);
              hh = false;
              setState(() {});
            } else if (state is Nodatafail) {
              hh = false;
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(' هناك خطأ في الاتصال بالشبكة حاول مرة اخري')));
            }
          },
          child: ModalProgressHUD(
            inAsyncCall: hh,
            child: Form(
              key: GG,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          custbutton(
                              x: 80,
                              hint: '5',
                              y: 10,
                              fun: () {
                                BlocProvider.of<NodataCubit>(context).nodata(5);
                              }),
                          custbutton(
                            x: 80,
                            hint: '10',
                            y: 10,
                            fun: () {
                              BlocProvider.of<NodataCubit>(context).nodata(10);
                            },
                          ),
                          custbutton(
                              x: 80,
                              hint: '15',
                              y: 10,
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(15);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '20',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(20);
                              }),
                          custbutton(
                              x: 80,
                              hint: '25',
                              y: 10,
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(25);
                              }),
                          custbutton(
                              x: 80,
                              hint: '30',
                              y: 10,
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(30);
                              }),
                          custbutton(
                              x: 80,
                              hint: '35',
                              y: 10,
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(35);
                              }),
                          custbutton(
                              x: 80,
                              hint: '40',
                              y: 10,
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(40);
                              }),
                          custbutton(
                              x: 80,
                              hint: '45',
                              y: 10,
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(45);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '50',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(50);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '100',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodata(100);
                              }),
                        ]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  custfiled(
                    val: (data) {
                      if (data!.isEmpty || int.parse(data) % 5 != 0) {
                        return 'قيمة خاطئة';
                      }
                      return null;
                    },
                    len: 3,
                    hh: [FilteringTextInputFormatter.digitsOnly],
                    jj: pp,
                    onfiledsubmited: (value) {
                      if (GG.currentState!.validate()) {
                        BlocProvider.of<NodataCubit>(context).nodata(value);
                        pp.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  DataTable _createDataTable(
      {required BuildContext context, required A, required B, required C}) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(context: context, A: A, B: B, C: C));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('الكود')),
      const DataColumn(label: Text(' صاحب البطاقة')),
      const DataColumn(label: Text('عدد الأرغفة'))
    ];
  }

  List<DataRow> _createRows(
      {required BuildContext context, required A, required B, required C}) {
    return [
      DataRow(cells: [DataCell(Text(A)), DataCell(Text(B)), DataCell(Text(C))]),
    ];
  }
}
