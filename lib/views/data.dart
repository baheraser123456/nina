import 'package:fina/cubit/cubit/vheck_cubit.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';

import 'package:fina/tools/button.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:fina/views/addion.dart';
import 'package:fina/views/history.dart';

import 'package:fina/views/printing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class hhh extends StatefulWidget {
  const hhh({super.key});
  static const name = 'hh';

  @override
  State<hhh> createState() => _hhhState();
}

class _hhhState extends State<hhh> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  int? now;
  String? password;
  bool isEditingPassword = false;
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(controller);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    // Clear password field after any pop-up
    passwordController.clear();
  }

  Widget _buildPasswordField(Map data, String id) {
    // Always start with empty password field
    if (!isEditingPassword) {
      passwordController.text = '';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        custfiled(
          hint: 'كلمة المرور',
          jj: passwordController,
          zz: false,
          hh: [FilteringTextInputFormatter.digitsOnly],
          len: 4,
          val: (val) {
            if (val == null || val.isEmpty) return 'حقل مطلوب';
            if (!isEditingPassword && val != (cubit.password ?? id)) return 'كلمة المرور غير صحيحة';
            if (isEditingPassword && (!RegExp(r'^\d{4}$').hasMatch(val))) return 'يجب أن تكون كلمة المرور 4 أرقام';
            return null;
          },
          onfiledsubmited: (_) {},
        ),
        Row(
          children: [
            if (!isEditingPassword)
              custbutton(
                hint: 'تعديل كلمة المرور',
                fun: () {
                  setState(() {
                    isEditingPassword = true;
                  });
                },
              ),
            if (isEditingPassword)
              custbutton(
                hint: 'حفظ كلمة المرور',
                fun: () async {
                  final newPass = passwordController.text;
                  if (newPass.isEmpty) {
                    _showSnackBar('كلمة المرور مطلوبة');
                    return;
                  }
                  if (!RegExp(r'^\d{4}$').hasMatch(newPass)) {
                    _showSnackBar('يجب أن تكون كلمة المرور 4 أرقام');
                    return;
                  }
                  try {
                    final response = await http.post(
                      Uri.parse('https://yourserver/update_password.php'),
                      body: {
                        'id': id,
                        'old_password': password,
                        'password': newPass,
                      },
                    );

                    final result = jsonDecode(response.body);
                    if (result['status'] == 'wrong_old_password') {
                      _showSnackBar('كلمة المرور القديمة غير صحيحة');
                    } else if (result['status'] == 'duplicate') {
                      _showSnackBar('كلمة المرور مستخدمة من قبل');
                    } else if (result['status'] == 'success') {
                      setState(() {
                        isEditingPassword = false;
                      });
                      _showSnackBar('تم تحديث كلمة المرور');
                    } else {
                      _showSnackBar('حدث خطأ أثناء تحديث كلمة المرور');
                    }
                  } catch (e) {
                    _showSnackBar('حدث خطأ أثناء تحديث كلمة المرور');
                  }
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustButtonRow(List<int> values, Map data, DatacubitState state, bool withPassword) {
    return Column(
      children: [
        for (int i = 0; i < values.length; i += 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 2 && i + j < values.length; j++)
                custbutton(
                  hint: values[i + j].toString(),
                  fun: () {
                    setState(() {
                      now = values[i + j];
                    });
                    int? dataNumber = data['number'] is int ? data['number'] : int.tryParse(data['number'].toString());
                    int? dataBk = data['bk'] is int ? data['bk'] : int.tryParse(data['bk'].toString());
                    // If password is required, check it first
                    if (data['per'] == 'باذن') {
                      if (passwordController.text.isEmpty) {
                        _showSnackBar('يرجى إدخال كلمة المرور');
                        return;
                      }
                      if (passwordController.text != (cubit.password ?? data['id'].toString())) {
                        _showSnackBar('كلمة المرور غير صحيحة');
                        return;
                      }
                    }
                    if (now == null) {
                      _showSnackBar('يرجى إدخال عدد صحيح');
                    } else if (dataNumber != null && now! > dataNumber) {
                      _showSnackBar('قيمة خاطئة: العدد أكبر من المتاح');
                    } else if (now! % 5 != 0) {
                      _showSnackBar('عدد الأرغفة يجب أن يكون من مضاعفات 5');
                    } else if (dataBk != null && dataBk > 0) {
                      BlocProvider.of<DatacubitCubit>(context).update(state as Datacubitsuc, context, now: now!, bk: now! / 5.0, password: data['per'] == 'باذن' ? passwordController.text : null);
                    } else if (dataBk != null && dataBk == 0) {
                      BlocProvider.of<DatacubitCubit>(context).update(state as Datacubitsuc, context, now: now!, bk: 0.0, password: data['per'] == 'باذن' ? passwordController.text : null);
                    } else {
                      _showSnackBar('قيمة خاطئة');
                    }
                  },
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildFormSection({
    required GlobalKey<FormState> GG,
    required Map data,
    required DatacubitState state,
    required bool withDayLimit,
  }) {
    final isBazn = data['per'] == 'باذن';
    return Form(
      key: GG,
      child: Scaffold(
        appBar: AppBar(title: const Text('البيانات')),
        body: ListView(
          children: [
            _createDataTable(
              context: context,
              A: data['id'],
              B: data['name'],
              C: data['number'],
              E: data['numbers'],
              F: data['last'],
              G: data['date'],
              H: data['per'],
              I: data['bk'],
            ),
            if (isBazn) _buildPasswordField(data, data['id'].toString()),
            const SizedBox(height: 70),
            custfiled(
              hint: 'عدد الارغفة',
              hh: [FilteringTextInputFormatter.digitsOnly],
              onfiledsubmited: (value) {
                setState(() {
                  now = int.tryParse(value);
                });
                // Safe parsing for all relevant fields
                int? dataNumber = data['number'] is int ? data['number'] : int.tryParse(data['number'].toString());
                int? dataStd = data['std'] is int ? data['std'] : int.tryParse(data['std'].toString());
                int? dataNumbers = data['numbers'] is int ? data['numbers'] : int.tryParse(data['numbers'].toString());
                int? dataBk = data['bk'] is int ? data['bk'] : int.tryParse(data['bk'].toString());
                // If password is required, check it first
                if (isBazn) {
                  if (passwordController.text.isEmpty) {
                    _showSnackBar('يرجى إدخال كلمة المرور');
                    return;
                  }
                  if (passwordController.text != (cubit.password ?? data['id'].toString())) {
                    _showSnackBar('كلمة المرور غير صحيحة');
                    return;
                  }
                }
                if (GG.currentState!.validate()) {
                  if (now == null) {
                    _showSnackBar('يرجى إدخال عدد صحيح');
                  } else if (now! <= 0) {
                    _showSnackBar('عدد الأرغفة يجب أن يكون أكبر من الصفر');
                  } else if (dataNumber != null && now! > dataNumber) {
                    _showSnackBar('قيمة خاطئة: العدد أكبر من المتاح');
                  } else if (now! % 5 != 0) {
                    _showSnackBar('عدد الأرغفة يجب أن يكون من مضاعفات 5');
                  } else if (withDayLimit &&
                      (dataStd != null && dataNumber != null && dataNumbers != null &&
                        ((dataStd - dataNumber + now!) / DateTime.now().day > dataNumbers * 5))) {
                    _showSnackBar('تخطيت الحد اليومي');
                  } else {
                    // Always update, use bk: now!/5.0
                    BlocProvider.of<DatacubitCubit>(context).update(
                      state as Datacubitsuc,
                      context,
                      now: now!,
                      bk: now! / 5.0,
                      password: isBazn ? passwordController.text : null,
                    );
                  }
                }
              },
              val: (dataVal) {
                if (dataVal == null || dataVal.isEmpty) {
                  return 'حقل مطلوب';
                }
                final parsed = int.tryParse(dataVal);
                if (parsed == null) {
                  return 'يرجى إدخال عدد صحيح';
                }
                if (parsed <= 0) {
                  return 'عدد الأرغفة يجب أن يكون أكبر من الصفر';
                }
                if (parsed % 5 != 0) {
                  return 'عدد الأرغفة يجب أن يكون من مضاعفات 5';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            if (withDayLimit)
              custbutton(
                hint: (int.parse(data['numbers']) * 5).toString(),
                fun: () {
                  setState(() {
                    now = int.parse(data['numbers']) * 5;
                  });
                  // If password is required, check it first
                  if (isBazn) {
                    if (passwordController.text.isEmpty) {
                      _showSnackBar('يرجى إدخال كلمة المرور');
                      return;
                    }
                    if (passwordController.text != (cubit.password ?? data['id'].toString())) {
                      _showSnackBar('كلمة المرور غير صحيحة');
                      return;
                    }
                  }
                  if (now! > int.parse(data['number'])) {
                    _showSnackBar('قيمة خاطئة');
                  } else if ((int.parse(data['std']) - int.parse(data['number']) + now!) / DateTime.now().day > int.parse(data['numbers']) * 5) {
                    _showSnackBar('تخطيت الحد اليومي');
                  } else {
                    // Always update, use bk: now!/5.0
                    BlocProvider.of<DatacubitCubit>(context).update(
                      state as Datacubitsuc,
                      context,
                      now: now!,
                      bk: now! / 5.0,
                      password: isBazn ? passwordController.text : null,
                    );
                  }
                },
              ),
            if (!withDayLimit)
              _buildCustButtonRow([5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 100], data, state, false),
            custbutton(
              hint: 'السجل',
              fun: () {
                Navigator.popAndPushNamed(context, history.name, arguments: data['id']);
              },
            ),
            custbutton(
              hint: "اضافة عيش",
              fun: () {
                List hh = [data['id'], data['name']];
                Navigator.popAndPushNamed(context, Addion.name, arguments: hh);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)!.settings.arguments as String;
    GlobalKey<FormState> GG = GlobalKey();
    BlocProvider.of<DatacubitCubit>(context).getdata(name);
    return BlocConsumer<DatacubitCubit, DatacubitState>(
      builder: (context, state) {
        if (state is Datacubitsuc) {
          final data = state.data['data'][0];
          // Handle all the different cases with extracted widgets
          if (data['stutas'] == 'true' && data['per'] == 'باذن' && data['day'] == 'يومي') {
            return _buildFormSection(GG: GG, data: data, state: state, withDayLimit: true);
          } else if (data['stutas'] == 'true' && data['per'] == 'بدون اذن' && data['day'] == 'يومي') {
            return _buildFormSection(GG: GG, data: data, state: state, withDayLimit: true);
          } else if (data['stutas'] == 'true' && data['per'] == 'باذن') {
            return _buildFormSection(GG: GG, data: data, state: state, withDayLimit: false);
          } else if (data['stutas'] == 'true' && data['per'] == 'بدون اذن') {
            return _buildFormSection(GG: GG, data: data, state: state, withDayLimit: false);
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(' هذا المستخدم محظور بسبب ${data['res']}')),
            );
          }
        } else if (state is Datacubitloading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Datacubitfail) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('هناك خطا في الشبكة')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
      },
      listener: (BuildContext context, DatacubitState state) {
        if (state is Datacubitsuc) {
          BlocProvider.of<DatacubitCubit>(context).hh = [
            BlocProvider.of<DatacubitCubit>(context).hh = [
              (BlocProvider.of<DatacubitCubit>(context).state as Datacubitsuc).data['data'][0]['name'],
              (BlocProvider.of<DatacubitCubit>(context).state as Datacubitsuc).data['data'][0]['id'].toString(),
            ];
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

  DataTable _createDataTable({
    required BuildContext context,
    required A,
    required B,
    required C,
    required E,
    required F,
    required G,
    required H,
    required I,
  }) {
    return DataTable(
      columns: _createColumns(),
      rows: [
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
      ],
    );
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
      const DataColumn(label: Text('الاشتراك')),
    ];
  }
}
