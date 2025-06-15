import 'package:cubit_form/cubit_form.dart';

import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class df extends StatefulWidget {
  const df({super.key});
  static const name = 'bb';

  @override
  State<df> createState() => _hhhState();
}

class _hhhState extends State<df> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  bool vv = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(controller);
  }

  double? now;
  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)!.settings.arguments as String;

    GlobalKey<FormState> GG = GlobalKey();

    BlocProvider.of<DatacubitCubit>(context).getdata(name);
    return BlocConsumer<DatacubitCubit, DatacubitState>(
        builder: (context, state) => state is Datacubitsuc
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
                          G: state.data['data'][0]['date'],
                          H: state.data['data'][0]['per'],
                          I: state.data['data'][0]['bk']),
                      const SizedBox(
                        height: 70,
                      ),
                      custfiled(
                        val: (data) {
                          if (data!.isEmpty) {
                            return 'قيمه خاطئة';
                          } else if (int.parse(data) % 5 != 0) {
                            return 'قيمه خاطئة';
                          }
                          return null;
                        },
                        hint: 'دفع',
                        hh: [FilteringTextInputFormatter.digitsOnly],
                        onfiledsubmited: (data) {
                          now = double.parse(data);
                          BlocProvider.of<DatacubitCubit>(context).updatefrk(
                            state.data['data'][0]['id'].toString(),
                            state.data['data'][0]['number'].toString(),
                          );
                        },
                      )
                    ])))
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
          if (state is cardssuc) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('تم دفع الاشتراك')));
          } else if (state is cardsfail) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("لم تم العملية حاول مرة اخري")));
          }
        });
  }

  DataTable _createDataTable(
      {required BuildContext context,
      required A,
      required B,
      required C,
      required E,
      required F,
      required G,
      required H,
      required I}) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(
            context: context, A: A, B: B, C: C, E: E, F: F, G: G, H: H, I: I));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('الكود')),
      const DataColumn(label: Text(' صاحب البطاقة')),
      const DataColumn(label: Text('عدد الأرغفة')),
      const DataColumn(label: Text('عدد الأفراد')),
      const DataColumn(label: Text('اخر سحب')),
      const DataColumn(label: Text('تاريخ ')),
      const DataColumn(label: Text('الاذن ')),
      const DataColumn(label: Text("الاشتراك")),
    ];
  }

  List<DataRow> _createRows(
      {required BuildContext context,
      required A,
      required B,
      required C,
      required E,
      required F,
      required G,
      required H,
      required I}) {
    return [
      DataRow(cells: [
        DataCell(Text(A.toString())),
        DataCell(Text(B)),
        DataCell(Text(C.toString())),
        DataCell(Text(E.toString())),
        DataCell(Text(F.toString())),
        DataCell(Text(G.toString())),
        DataCell(Text(H.toString())),
        DataCell(Text(I.toString())),
      ]),
    ];
  }
}
