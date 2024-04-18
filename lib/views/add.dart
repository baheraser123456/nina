import 'package:fina/tools/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../addcubit/cubit/add_cubit.dart';

import '../getcubit/get_cubit.dart';
import '../tools/txtfiled.dart';

class add extends StatefulWidget {
  const add({super.key});
  static String name = 'add';

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  String? num;

  String? names;

  String? id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddCubit, AddState>(
      listener: (context, state) {
        if (state is Sucadd) {
          Navigator.pop(context);
          BlocProvider.of<GetCubit>(context).gets();
        } else if (state is Failadd) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لم تتم العملية حاول مرة اخري')));
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: BlocProvider.of<AddCubit>(context).key,
          child: ListView(
            children: [
              custfiled(
                onsaved: (data) {
                  names = data;
                },
                hint: 'اسم صاحب البطاقة',
                val: (data) {
                  if (data!.isEmpty) {
                    return 'بيانات خاطئة';
                  } else if (BlocProvider.of<GetCubit>(context)
                      .gata
                      .contains(data)) {
                    return 'موجود بالفعل';
                  }
                  return null;
                },
                hh: [FilteringTextInputFormatter.allow(RegExp('[ا-ي ,ئ,ء,ؤ]'))],
              ),
              custfiled(
                  onsaved: (data) {
                    num = data;
                  },
                  hint: 'عدد الأفراد',
                  hh: [FilteringTextInputFormatter.digitsOnly],
                  val: (data) {
                    if (data!.isEmpty) {
                      return 'بيانات خاطئة';
                    }
                    return null;
                  }),
              GestureDetector(
                child: custbutton(
                  hint: 'اضافة',
                ),
                onTap: () {
                  if (BlocProvider.of<AddCubit>(context)
                      .key
                      .currentState!
                      .validate()) {
                    BlocProvider.of<AddCubit>(context)
                        .add(name: names, number: num);
                  } else {
                    AutovalidateMode.always;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
