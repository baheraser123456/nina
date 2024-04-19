import 'package:fina/datacubit/datacubit_cubit.dart';

import 'package:fina/tools/txtfiled.dart';
import 'package:fina/views/cardsprinting.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class cardspage extends StatefulWidget {
  const cardspage({super.key});
  static const name = 'cards';

  @override
  State<cardspage> createState() => _hhhState();
}

class _hhhState extends State<cardspage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  bool vv = false;
  String? value;
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

  int? now;
  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;
    String name = hh[0];
    int mon = hh[1];

    GlobalKey<FormState> GG = GlobalKey();

    BlocProvider.of<DatacubitCubit>(context).getcard(name);
    return BlocConsumer<DatacubitCubit, DatacubitState>(
      builder: (context, state) => state is Datacubitsuc
          ? ModalProgressHUD(
              inAsyncCall: vv,
              child: Form(
                key: GG,
                child: Scaffold(
                    appBar: AppBar(
                      title: Text('اشتراك شهر $mon'),
                    ),
                    body: ListView(children: [
                      _createDataTable(
                          context: context,
                          B: state.data['data'][0]['name'],
                          A: state.data['data'][0]['id'],
                          E: state.data['data'][0]['numbers'],
                          G: state.data['data'][0]['value'],
                          C: 'تم دفع ${state.data['data'][0]['$mon']} من ${state.data['data'][0]['value']}'),
                      const SizedBox(
                        height: 70,
                      ),
                      custfiled(
                        hh: [FilteringTextInputFormatter.digitsOnly],
                        onfiledsubmited: (data) {
                          value = data;
                          if (GG.currentState!.validate()) {
                            BlocProvider.of<DatacubitCubit>(context).updatecard(
                                state.data['data'][0]['name'],
                                state.data['data'][0]['id'].toString(),
                                mon,
                                data);
                          }
                        },
                        hint: 'دفع الاشتراك',
                        val: (data) {
                          if (data!.isEmpty) {
                            return 'حقل مطلوب';
                          } else if (int.parse(data) == 0 ||
                              int.parse(data) >
                                  state.data['data'][0]['value'] -
                                      int.parse(
                                          state.data['data'][0]['$mon'])) {
                            return 'قيمه خاطئة';
                          }
                          return null;
                        },
                      )
                    ])),
              ),
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
        if (state is cardsload) {
          vv = true;
          setState(() {});
        } else if (state is cardsfail) {
          vv = false;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لم تتم العملية بنجاح')));
        } else if (state is cardssuc) {
          List bb = [name, value, mon];
          vv = false;
          setState(() {});
          Navigator.popAndPushNamed(context, cardsprinting.name, arguments: bb);
        }
      },
    );
  }
}

DataTable _createDataTable({
  required BuildContext context,
  required A,
  required B,
  required E,
  required G,
  required C,
}) {
  return DataTable(
      columns: _createColumns(),
      rows: _createRows(context: context, A: A, B: B, E: E, G: G, C: C));
}

List<DataColumn> _createColumns() {
  return [
    const DataColumn(label: Text('الكود')),
    const DataColumn(label: Text(' صاحب البطاقة')),
    const DataColumn(label: Text('عدد الأفراد')),
    const DataColumn(label: Text('قيمة الاشتراك')),
    const DataColumn(label: Text('المدفوع')),
  ];
}

List<DataRow> _createRows({
  required BuildContext context,
  required A,
  required B,
  required E,
  required G,
  required C,
}) {
  return [
    DataRow(cells: [
      DataCell(Text(A.toString())),
      DataCell(Text(B)),
      DataCell(Text(E.toString())),
      DataCell(Text(G.toString())),
      DataCell(Text(C.toString())),
    ]),
  ];
}
