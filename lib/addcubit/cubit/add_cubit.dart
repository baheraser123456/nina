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

  addcard({required name, required number, required place}) async {
    int? value;
    switch (number) {
      case '1':
        value = 25;
      case '2':
        value = 25;
      case '3':
        value = 35;
      case '4':
        value = 45;
      case '5':
        value = 55;
      case '6':
        value = 65;
      case '7':
        value = 70;
      case '8':
        value = 75;
    }

    try {
      var res = await post(addcardurl, {
        'name': name,
        'numbers': number,
        'place': place,
        'value': value.toString()
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

  addion({required id, required number}) async {
    try {
      var res = await post(addionurl, {
        'id': id,
        'number': number,
        'date': DateTime.now().toString(),
      });
      if (res == 'wrong') {
        emit(Failaddion());
      } else {
        emit(Sucaddion());
      }
    } on Exception {
      emit(Failaddion());
    }
  }
}
