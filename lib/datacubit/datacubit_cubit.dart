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
  getdata(String name) async {
    emit(Datacubitloading());

    var response = await post(getname, {'name': name});
    if (response == 'wrong') {
      emit(Datacubitfail('خطأ في الشبكة'));
    } else {
      emit(Datacubitsuc(response));
    }
  }

  getcard(String name) async {
    emit(Datacubitloading());

    var response = await post(getnamecards, {'name': name});
    if (response == 'wrong') {
      emit(Datacubitfail('خطأ في الشبكة'));
    } else {
      emit(Datacubitsuc(response));
    }
  }

  void update(Datacubitsuc state, BuildContext context,
      {required int now, required double bk}) async {
    emit(Datacubitloading());
    if (now < int.parse(state.data['data'][0]['number']) ||
        now == int.parse(state.data['data'][0]['number'])) {
      int zz = int.parse(state.data['data'][0]['number']) - now;

      initializeDateFormatting("ar_SA", null);
      var nows = DateTime.now();
      var formatter = DateFormat.MMMd('ar_SA');

      String formatted = formatter.format(nows);
      initializeDateFormatting("ar_SA", null);
      var nowss = DateTime.now();
      var formatters = DateFormat.Hm('ar_SA');

      String formatteds = formatters.format(nowss);
      var res = await post(updatenum, {
        'ip': state.data['data'][0]['id'].toString(),
        'name': state.data['data'][0]['name'],
        'number': zz.toString(),
        'last': now.toString(),
        'date': formatted + formatteds,
        'total': DateTime.now().day.toString(),
        'totals': now.toString(),
        'pro': now.toString(),
        'bk': bk.toString()
      });
      if (res == 'wrong') {
        emit(Datacubitfail('خطأ في الشبكة'));
      } else {
        emit(Datacubitsucs(zz, res));
      }
    }
  }

  getlast() async {
    emit(Datacubitloading());
    try {
      var response = await getnames(getlastout);

      emit(Datacubitsuc(response));
      if (response == 'wrong') {
        emit(Datacubitfail('خطأ في الشبكة'));
      }
    } on Exception {
      emit(Datacubitfail('خطأ في الشبكة'));
    }
  }

  void updatecard(String name, String ip, mon, now) async {
    emit(cardsload());
    var res = await post(updatecards, {
      'ip': ip,
      'date': DateTime.now().toString(),
      'name': name,
      'mon': mon.toString(),
      'now': now.toString(),
      'total': DateTime.now().day.toString()
    });

    if (res == 'wrong') {
      emit(cardsfail());
    } else {
      emit(cardssuc());
    }
  }

  void updatbk({required String name, required String ip, required now}) async {
    emit(cardsload());
    var res = await post(dfs, {
      'ip': ip.toString(),
      'date': DateTime.now().toString(),
      'name': name,
      "bk": now.toString(),
      'total': DateTime.now().day.toString(),
      'totals': (now * 20).toString()
    });

    if (res == 'wrong') {
      emit(cardsfail());
    } else {
      emit(cardssuc());
    }
  }

  gethis(ip) async {
    emit(Datacubitloading());

    var response = await post(his, {'ip': ip.toString()});
    if (response == 'wrong') {
      emit(Datacubitfail('خطأ في الشبكة'));
    } else {
      emit(Datacubitsuc(response));
    }
  }
}
