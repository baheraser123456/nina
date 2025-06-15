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
        emit(Failadd(txt: 'خطأ في الشبكة'));
      } else {
        emit(Sucadd());
      }
    } on FormatException catch (e) {
      print('Data format error: $e');
      emit(Failadd(txt: 'خطأ في تنسيق البيانات'));
    } on Exception catch (e) {
      print('Unexpected error: $e');
      emit(Failadd(txt: e.toString()));
    }
  }

  addcard({required name, required number, required place}) async {
    try {
      var res = await post(addcardurl, {
        'name': name,
        'numbers': number,
        'place': place,
        'value': (int.parse(number)*30).toString(),
      });
      if (res == 'wrong') {
        emit(Failadd(txt: 'خطأ في الشبكة'));
      } else {
        emit(Sucadd());
      }
    } on FormatException catch (e) {
      print('Data format error: $e');
      emit(Failadd(txt: 'خطأ في تنسيق البيانات'));
    } on Exception catch (e) {
      print('Unexpected error: $e');
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
    } on FormatException catch (e) {
      print('Data format error: $e');
      emit(Failaddion());
    } on Exception catch (e) {
      print('Unexpected error: $e');
      emit(Failaddion());
    }
  }
}
