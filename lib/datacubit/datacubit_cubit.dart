import 'package:bloc/bloc.dart';

import 'package:fina/constants.dart';
import 'package:fina/html.dart';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

part 'datacubit_state.dart';

class DatacubitCubit extends Cubit<DatacubitState> {
  DatacubitCubit() : super(DatacubitInitial());
  bool vv = false;
  List hh = [];

  void _handleError(dynamic error, String operation) {
    print('Error in $operation: $error');
    if (error is NetworkException) {
      emit(Datacubitfail('خطأ في الاتصال بالشبكة. يرجى التحقق من اتصال الإنترنت'));
    } else if (error is DataFormatException) {
      emit(Datacubitfail('خطأ في تنسيق البيانات. يرجى المحاولة مرة أخرى'));
    } else if (error is ServerException) {
      emit(Datacubitfail('خطأ في الخادم. يرجى المحاولة لاحقاً'));
    } else {
      emit(Datacubitfail('حدث خطأ في النظام. يرجى المحاولة مرة أخرى'));
    }
  }

  getdata(String name) async {
    if (name.isEmpty) {
      emit(Datacubitfail('الرجاء إدخال اسم صحيح'));
      return;
    }

    emit(Datacubitloading());
    try {
      var response = await post(getname, {'name': name});
      if (response == null) {
        emit(Datacubitfail('لم يتم العثور على بيانات'));
        return;
      }
      emit(Datacubitsuc(response));
    } catch (e) {
      _handleError(e, 'getdata');
    }
  }

  getcard(String name) async {
    if (name.isEmpty) {
      emit(Datacubitfail('الرجاء إدخال اسم صحيح'));
      return;
    }

    emit(Datacubitloading());
    try {
      var response = await post(getnamecards, {'name': name});
      if (response == null) {
        emit(Datacubitfail('لم يتم العثور على بيانات'));
        return;
      }
      emit(Datacubitsuc(response));
    } catch (e) {
      _handleError(e, 'getcard');
    }
  }

  getcards(String name) async {
    if (name.isEmpty) {
      emit(Datacubitfail('الرجاء إدخال اسم صحيح'));
      return;
    }

    emit(Datacubitloading());
    try {
      var response = await post(getnamecardss, {'name': name});
      if (response == null) {
        emit(Datacubitfail('لم يتم العثور على بيانات'));
        return;
      }
      emit(Datacubitsuc(response));
    } catch (e) {
      _handleError(e, 'getcards');
    }
  }

  getdatas(String id) async {
    if (id.isEmpty) {
      emit(Datacubitfail('معرف المستخدم غير صالح'));
      return;
    }

    emit(Datacubitloading());
    try {
      var response = await post(frkurl, {'id': id});
      
      if (response == null) {
        emit(Datacubitfail('لم يتم العثور على بيانات'));
        return;
      }

      if (response['data'] == null || response['data'].isEmpty) {
        emit(Datacubitfail('لا يوجد فرق عيش'));
        return;
      }

      emit(Datacubitsuc(response));
    } catch (e) {
      _handleError(e, 'getdatas');
    }
  }

  void update(Datacubitsuc state, BuildContext context,
      {required int now, required double bk, String? password}) async {
    if (state.data['data'] == null || state.data['data'].isEmpty) {
      emit(Datacubitfail('لا توجد بيانات للتحديث'));
      return;
    }

    emit(Datacubitloading());
    try {
      if (now < int.parse(state.data['data'][0]['number']) ||
          now == int.parse(state.data['data'][0]['number'])) {
        int zz = int.parse(state.data['data'][0]['number']) - now;

        initializeDateFormatting("ar_SA", null);
        var nows = DateTime.now();
        var formatter = DateFormat.MMMd('ar_SA');
        String formatted = formatter.format(nows);
        
        var nowss = DateTime.now();
        var formatters = DateFormat.Hm('ar_SA');
        String formatteds = formatters.format(nowss);

        var req = {
          'ip': state.data['data'][0]['id'].toString(),
          'name': state.data['data'][0]['name'],
          'number': zz.toString(),
          'last': now.toString(),
          'date': formatted + formatteds,
          'total': DateTime.now().day.toString(),
          'totals': now.toString(),
          'pro': now.toString(),
          'bk': bk.toString()
        };
        if (password != null) {
          req['password'] = password;
        }

        var res = await post(updatenum, req);
        if (res == null) {
          emit(Datacubitfail('فشل التحديث'));
          return;
        }
        emit(Datacubitsucs(zz, res));
      } else {
        emit(Datacubitfail('القيمة المدخلة غير صالحة'));
      }
    } catch (e) {
      _handleError(e, 'update');
    }
  }

  getlast() async {
    emit(Datacubitloading());
    try {
      var response = await getnames(getlastout);
      if (response == null) {
        emit(Datacubitfail('لم يتم العثور على بيانات'));
        return;
      }
      emit(Datacubitsuc(response));
    } catch (e) {
      _handleError(e, 'getlast');
    }
  }

  gethis(ip) async {
    if (ip == null || ip.toString().isEmpty) {
      emit(Datacubitfail('معرف المستخدم غير صالح'));
      return;
    }

    emit(Datacubitloading());
    try {
      var response = await post(his, {'ip': ip.toString()});
      if (response == null) {
        emit(Datacubitfail('لم يتم العثور على بيانات'));
        return;
      }
      emit(Datacubitsuc(response));
    } catch (e) {
      _handleError(e, 'gethis');
    }
  }

  updatefrk(id, number) async {
    if (id == null || id.toString().isEmpty) {
      emit(frkfail());
      return;
    }

    final numberValue = int.tryParse(number.toString());
    if (numberValue == null || numberValue <= 0) {
      emit(frkfail());
      return;
    }

    emit(frkload());
    try {
      var response = await post(upfrk, {
        'id': id,
        'date': DateTime.now().toString(),
        'number': number,
      });

      if (response == null) {
        emit(frkfail());
        return;
      }

      emit(frksuc());
    } catch (e) {
      print('Error in updatefrk: $e');
      emit(frkfail());
    }
  }

  Future<void> updatePassword({required String id, required String password}) async {
    if (id.isEmpty) {
      emit(Datacubitfail('معرف المستخدم غير صالح'));
      return;
    }

    if (password.isEmpty) {
      emit(Datacubitfail('الرجاء إدخال كلمة مرور صحيحة'));
      return;
    }

    emit(Datacubitloading());
    try {
      var res = await post(update_password, {
        'id': id,
        'password': password,
      });
      if (res == null) {
        emit(Datacubitfail('فشل تحديث كلمة المرور'));
        return;
      }
      emit(Datacubitsuc(res));
    } catch (e) {
      _handleError(e, 'updatePassword');
    }
  }

  Future<void> deleteOperation({required String id, required String last, required String password}) async {
    if (id.isEmpty) {
      emit(Datacubitfail('معرف المستخدم غير صالح'));
      return;
    }

    if (password.isEmpty) {
      emit(Datacubitfail('الرجاء إدخال كلمة مرور صحيحة'));
      return;
    }

    emit(Datacubitloading());
    try {
      var res = await post('delete_operation', {
        'id': id,
        'last': last,
        'password': password,
      });
      if (res == null) {
        emit(Datacubitfail('فشل حذف العملية'));
        return;
      }
      emit(Datacubitsuc(res));
    } catch (e) {
      _handleError(e, 'deleteOperation');
    }
  }

  void updatecardz(String name, String ip, int mon, String now) async {
    emit(cardsload());
    try {
      var res = await post(updatecards, {
        'ip': ip,
        'date': DateTime.now().toString(),
        'name': name,
        'mon': mon.toString(),
        'now': now,
        'total': DateTime.now().day.toString()
      });

      if (res == null) {
        emit(cardsfail());
        return;
      }
      emit(cardssuc());
    } catch (e) {
      print('Error in updatecardz: $e');
      emit(cardsfail());
    }
  }
}
