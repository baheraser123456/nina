import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:fina/cubit/cubit/vheck_cubit.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/tools/button.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:fina/views/addion.dart';
import 'package:fina/views/edit.dart';
import 'package:fina/views/history.dart';
import 'package:fina/views/printing.dart';

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
  bool _isAuthenticated = false;
  bool _hasCheckedAuth = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedAuth) {
      _hasCheckedAuth = true;
      final name = ModalRoute.of(context)!.settings.arguments as String;
      BlocProvider.of<DatacubitCubit>(context).getdata(name);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _checkAuthentication();
      });
    }
  }

  Future<void> _checkAuthentication() async {
    final state = BlocProvider.of<DatacubitCubit>(context).state;
    if (state is! Datacubitsuc) return;

    final data = state.data['data'][0];
    final pass = data['pass'].toString();

    if (data['per'] == 'باذن') {
      if (pass == '0000') {
        _showSnackBar('يجب تغيير كلمة المرور الافتراضية أولاً');
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      final enteredPassword = await _showPasswordDialog();
      if (!mounted || enteredPassword == null) {
        Navigator.of(context).pop();
        return;
      }

      if (enteredPassword == pass) {
        setState(() {
          _isAuthenticated = true;
          password = enteredPassword;
        });
      } else {
        _showSnackBar('كلمة المرور غير صحيحة');
        Navigator.of(context).pop();
      }
    } else {
      setState(() => _isAuthenticated = true);
    }
  }

  void _redirectToEdit(id) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showSnackBar('يجب تغيير كلمة المرور الافتراضية أولاً');
        Navigator.of(context).popAndPushNamed(Edit.name, arguments: id);
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String?> _showPasswordDialog() async {
    String passwordInput = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('أدخل كلمة المرور'),
        content: TextField(
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(hintText: 'كلمة المرور'),
          onChanged: (val) => passwordInput = val,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              if (passwordInput.isEmpty) {
                _showSnackBar('كلمة المرور مطلوبة');
                return;
              }
              Navigator.of(context).pop(passwordInput);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<int> values, Map data) {
    return Column(
      children: [
        for (int i = 0; i < values.length; i += 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 2 && i + j < values.length; j++)
                custbutton(
                  hint: values[i + j].toString(),
                  fun: () => _onSubmit(nowValue: values[i + j], data: data),
                ),
            ],
          ),
      ],
    );
  }

  Future<void> _onSubmit({required int nowValue, required Map data}) async {
    setState(() => now = nowValue);
    final cubit = BlocProvider.of<DatacubitCubit>(context);
    final state = cubit.state;

    if (state is! Datacubitsuc) return;

    final dataNumber = int.tryParse(data['number'].toString());
    if (now == null || dataNumber == null) return;

    if (now! > dataNumber) {
      _showSnackBar('قيمة خاطئة: العدد أكبر من المتاح');
    } else if (now! % 5 != 0) {
      _showSnackBar('عدد الأرغفة يجب أن يكون من مضاعفات 5');
    } else {
      cubit.update(state, context, now: now!, bk: now! / 5.0);
    }
  }

  Widget _buildFormSection({
    required GlobalKey<FormState> formKey,
    required Map data,
    required DatacubitState state,
    required bool withDayLimit,
  }) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('البيانات')),
        body: ListView(
          children: [
            _createDataTable(data),
            const SizedBox(height: 70),
            custfiled(
              hint: 'عدد الارغفة',
              hh: [FilteringTextInputFormatter.digitsOnly],
              onfiledsubmited: (value) async {
                final parsed = int.tryParse(value);
                if (parsed != null) _onSubmit(nowValue: parsed, data: data);
              },
              val: (val) {
                if (val == null || val.isEmpty) return 'حقل مطلوب';
                final parsed = int.tryParse(val);
                if (parsed == null) return 'يرجى إدخال عدد صحيح';
                if (parsed <= 0) return 'عدد الأرغفة يجب أن يكون أكبر من الصفر';
                if (parsed % 5 != 0) return 'عدد الأرغفة يجب أن يكون من مضاعفات 5';
                return null;
              },
            ),
            const SizedBox(height: 10),
            if (withDayLimit)
              custbutton(
                hint: (int.parse(data['numbers']) * 5).toString(),
                fun: () => _onSubmit(nowValue: int.parse(data['numbers']) * 5, data: data),
              )
            else
              _buildButtonRow([5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 100], data),
            custbutton(
              hint: 'السجل',
              fun: () => Navigator.popAndPushNamed(context, history.name, arguments: data['id']),
            ),
            custbutton(
              hint: "اضافة عيش",
              fun: () => Navigator.popAndPushNamed(context, Addion.name, arguments: [data['id'], data['name']]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocConsumer<DatacubitCubit, DatacubitState>(
      builder: (context, state) {
        if (state is Datacubitsuc) {
          final data = state.data['data'];
          if (data == null || data.isEmpty) {
            Navigator.of(context).pop();
            return _loading();
          }

          final userData = data[0];
          if (!_isAuthenticated) return _loading();

          return userData['stutas'] == 'true'
              ? _buildFormSection(
                  formKey: formKey,
                  data: userData,
                  state: state,
                  withDayLimit: userData['day'] == 'يومي',
                )
              : Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('هذا المستخدم محظور بسبب ${userData['res']}')),
                );
        }
        return _loading();
      },
      listener: (context, state) {
        final cubit = BlocProvider.of<DatacubitCubit>(context);
        if (state is Datacubitsuc) {
          final data = state.data['data'];
          if (data != null && data.isNotEmpty) {
            cubit.hh = [data[0]['name'], data[0]['id'].toString()];
          }
        }

        if (state is Datacubitsucs) {
          final data = state.data['data'];
          if (data != null && data.isNotEmpty) {
            cubit.hh.insert(1, now.toString());
            cubit.hh.insert(2, state.zz);
            cubit.hh.add(data[0]['id']);
            Navigator.of(context).popAndPushNamed(Printing.name, arguments: cubit.hh);
          }
        }
      },
    );
  }

  Scaffold _loading() => const Scaffold(body: Center(child: CircularProgressIndicator()));

  DataTable _createDataTable(Map data) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('الكود')),
        DataColumn(label: Text('صاحب البطاقة')),
        DataColumn(label: Text('عدد الأرغفة')),
        DataColumn(label: Text('عدد الأفراد')),
        DataColumn(label: Text('اخر سحب')),
        DataColumn(label: Text('تاريخ')),
        DataColumn(label: Text('الاذن')),
        DataColumn(label: Text('الاشتراك')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text(data['id'].toString())),
          DataCell(Text(data['name'])),
          DataCell(Text(data['number'].toString())),
          DataCell(Text(data['numbers'].toString())),
          DataCell(Text(data['last'].toString())),
          DataCell(Text(data['date'].toString())),
          DataCell(Text(data['per'].toString())),
          DataCell(Text(data['bk'].toString())),
        ]),
      ],
    );
  }
}
