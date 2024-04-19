import 'package:fina/tools/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../addcubit/cubit/add_cubit.dart';

import '../tools/txtfiled.dart';

class Addcard extends StatefulWidget {
  const Addcard({super.key});
  static String name = 'addcard';

  @override
  State<Addcard> createState() => _AddcardState();
}

class _AddcardState extends State<Addcard> {
  String? num;

  String? names;

  String? id;
  String? place;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddCubit, AddState>(
      listener: (context, state) {
        if (state is Sucadd) {
          Navigator.pop(context);
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
                  place = data;
                },
                hint: 'المكان',
                val: (data) {
                  if (data!.isEmpty) {
                    return 'بيانات خاطئة';
                  }
                  return null;
                },
                hh: [FilteringTextInputFormatter.allow(RegExp('[ا-ي ,ئ,ء,ؤ]'))],
              ),
              custfiled(
                onsaved: (data) {
                  names = data;
                },
                hint: 'اسم صاحب البطاقة',
                val: (data) {
                  if (data!.isEmpty) {
                    return 'بيانات خاطئة';
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
                    BlocProvider.of<AddCubit>(context).addcard(
                      name: names,
                      number: num,
                      place: place,
                    );
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
