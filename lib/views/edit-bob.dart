import 'package:fina/cubit2/editcubit_cubit.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});
  static const name = 'Edit';

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  String? hhh;
  String? id;
  String? newname;
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
                        B: state.data['data'][0]['name'].toString(),
                        A: state.data['data'][0]['id'],
                        C: state.data['data'][0]['numbers']),
                    const SizedBox(
                      height: 50,
                    ),
                    custfiled(
                      hh: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[ا-ي ,ئ,ء,ؤ,أ]'))
                      ],
                      hint: 'الاسم',
                      onsaved: (data) {
                        newname = data;
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'عدد الأفراد',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == '0' ||
                                value == state.data['data'][0]['numbers']) {
                              return 'قيمة خاطئة';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            hhh = value;
                          },
                        )),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: BlocListener<EditcubitCubit, EditcubitState>(
                          listener:
                              (BuildContext context, EditcubitState state) {
                            if (state is Editcubitfail) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('هناك خطأ ما حاول مرة أخري')));
                            } else if (state is Editcubitsuc &&
                                GG.currentState!.validate()) {
                              Navigator.pop(context);
                              BlocProvider.of<GetCubit>(context).gets();
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              BlocProvider.of<EditcubitCubit>(context).edit(
                                  ip: state.data['data'][0]['id'].toString(),
                                  names:
                                      newname ?? state.data['data'][0]['name'],
                                  name: state.data['data'][0]['name'],
                                  number: (int.parse(
                                              state.data['data'][0]['number']) +
                                          (150 *
                                              (int.parse(hhh ??
                                                      state.data['data'][0]
                                                          ['numbers']) -
                                                  int.parse(state.data['data']
                                                      [0]['numbers']))))
                                      .toString(),
                                  numbers:
                                      hhh ?? state.data['data'][0]['numbers']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  width: 100,
                                  color: Colors.blue,
                                  child: const Center(child: Text('تعديل')),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
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
      const DataColumn(label: Text('الكود')),
      const DataColumn(label: Text(' صاحب البطاقة')),
      const DataColumn(label: Text('عدد الأفراد'))
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
