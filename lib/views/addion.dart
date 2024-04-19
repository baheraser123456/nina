import 'package:fina/tools/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../addcubit/cubit/add_cubit.dart';

import '../tools/txtfiled.dart';

class Addion extends StatefulWidget {
  const Addion({super.key});
  static String name = 'addion';

  @override
  State<Addion> createState() => _AddionState();
}

class _AddionState extends State<Addion> {
  String? num;

  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;
    String ip = hh[0].toString();
    String names = hh[1];
    return BlocListener<AddCubit, AddState>(
      listener: (context, state) {
        if (state is Sucaddion) {
          Navigator.pop(context);
        } else if (state is Failaddion) {
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
                    num = data;
                  },
                  hint: 'عدد الارغفة',
                  hh: [FilteringTextInputFormatter.digitsOnly],
                  val: (data) {
                    if (data!.isEmpty ||
                        int.parse(data) % 5 != 0 ||
                        int.parse(data) == 0) {
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
                        .addion(id: ip, number: num);
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
