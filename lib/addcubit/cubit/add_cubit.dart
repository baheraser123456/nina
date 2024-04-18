import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

import 'package:flutter/material.dart';

part 'add_state.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit() : super(Initialadd());
  GlobalKey<FormState> key = GlobalKey();
  add({required name, required number}) async {
    try {
      var res = await post(addurl, {
        'name': name,
        'number': number,
        'numbers': number,
      });
      if (res == 'wrong') {
        emit(Failadd(txt: 'حطأ في الشبكة'));
      } else {
        emit(Sucadd());
      }
    } on Exception catch (e) {
      emit(Failadd(txt: e.toString()));
    }
  }
}
