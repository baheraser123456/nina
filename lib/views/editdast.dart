import 'package:fina/constants.dart';

import 'package:fina/datacubit/datacubit_cubit.dart';

import 'package:fina/html.dart';
import 'package:fina/views/printing.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class EditLast extends StatefulWidget {
  const EditLast({super.key});
  static const String name = 'editlast';
  @override
  State<EditLast> createState() => _EditLast();
}

class _EditLast extends State<EditLast> {
  int? now;
  dynamic newlast;
  int? newnum;

  GlobalKey<FormState> GG = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String kk = ModalRoute.of(context)!.settings.arguments as String;

    BlocProvider.of<DatacubitCubit>(context).getdata(kk);

    return BlocBuilder<DatacubitCubit, DatacubitState>(
        builder: (context, state) {
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
                      B: state.data['data'][0]['date'].toString(),
                      A: state.data['data'][0]['name'],
                      C: state.data['data'][0]['last']),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'عدد الأرغفة',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (int.tryParse(value!)! -
                                  int.parse(state.data['data'][0]['last']) >
                              int.tryParse(state.data['data'][0]['number'])!) {
                            return 'قيمة خاطئة';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) async {
                          now = int.tryParse(value);
                          if (GG.currentState!.validate()) {
                            newlast =
                                now! - int.parse(state.data['data'][0]['last']);
                            initializeDateFormatting("ar_SA", null);
                            var nows = DateTime.now();
                            var formatter = DateFormat.MMMd('ar_SA');

                            String formatted = formatter.format(nows);
                            initializeDateFormatting("ar_SA", null);
                            var nowss = DateTime.now();
                            var formatters = DateFormat.Hm('ar_SA');
                            String formatteds = formatters.format(nowss);
                            String jj =
                                (int.parse(state.data['data'][0]['number']) -
                                        newlast!)
                                    .toString();
                            var res =
                                await editast(formatted, formatteds, jj, state);

                            List hh = [
                              state.data['data'][0]['name'],
                              now,
                              jj,
                              state.data['data'][0]['id'],
                              res['data'][0]['id']
                            ];
                            if (res['stutas'] == 'success') {
                              Navigator.pushNamed(context, Printing.name,
                                  arguments: hh);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('هناك خطأ ما')));
                            }
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

  editast(String formatted, String formatteds, String jj,
      Datacubitsuc state) async {
    var res = await post(editlasturl, {
      "last": now.toString(),
      "date": formatted + formatteds,
      "number": jj,
      "name": state.data['data'][0]['name'],
      "totals": newlast.toString(),
      "total": DateTime.now().day.toString(),
      'pro': "edit''${now.toString()}",
      "ip": state.data['data'][0]['id'].toString()
    });
    if (res['stutas'] == 'success') {
      return res;
    } else {
      return 'fail';
    }
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
      const DataColumn(label: Text(' تاريخ')),
      const DataColumn(label: Text('عميلة السحب'))
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
