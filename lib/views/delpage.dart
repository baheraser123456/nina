import 'package:fina/cubit/delcubit_cubit.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/getcubit/get_cubit.dart';

import 'package:fina/tools/button.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Delete extends StatefulWidget {
  const Delete({super.key});
  static const name = 'delpage';

  @override
  State<Delete> createState() => _EditState();
}

class _EditState extends State<Delete> {
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
                        B: state.data['data'][0]['numbers'].toString(),
                        A: state.data['data'][0]['name'],
                        C: state.data['data'][0]['number']),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: BlocListener<DelcubitCubit, DelcubitState>(
                          listener: (context, state) {
                            if (state is Delcubitsuc) {
                              Navigator.pop(context);
                              BlocProvider.of<GetCubit>(context).gets();
                            } else if (state is Delcubitfail) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('العملية لم تتم')));
                            }
                          },
                          child: custbutton(
                            hint: 'حذف',
                            fun: () {
                              BlocProvider.of<DelcubitCubit>(context).del(
                                  ip: state.data['data'][0]['number']
                                      .toString(),
                                  name: state.data['data'][0]['name'],
                                  date: state.data['data'][0]['numbers']);
                            },
                          ),
                        ),
                      ),
                    )
                  ])));
        } else if (state is Datacubitloading) {
          return const Scaffold(
            body: Center(
                child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('هناك خطا في الشبكة')),
          );
        }
      },
    );
  }

  DataTable _createDataTable(
      {required BuildContext context, required A, required B, required C}) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(context: context, A: A, B: B, C: C));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('الاسم')),
      const DataColumn(label: Text("عدد الافراد")),
      const DataColumn(label: Text("المتبقي"))
    ];
  }

  List<DataRow> _createRows(
      {required BuildContext context, required A, required B, required C}) {
    return [
      DataRow(cells: [
        DataCell(Text(A.toString())),
        DataCell(Text(B)),
        DataCell(Text(C))
      ]),
    ];
  }
}
