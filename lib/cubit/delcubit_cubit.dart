import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

part 'delcubit_state.dart';

class DelcubitCubit extends Cubit<DelcubitState> {
  DelcubitCubit() : super(DelcubitInitial());
  del({ip, name, date}) async {
    emit(Delcubitload());

    var res = post(deleteurl, {
      'name': name,
      'date': date,
      'ip': ip,
    });

    if (res == 'wrong') {
      emit(Delcubitfail(err: 'wrog'));
    } else {
      emit(Delcubitsuc(res: res));
    }
  }

  delcard({ip, name, date}) async {
    emit(Delcubitload());

    var res = post(delcards, {
      'name': name,
      'date': date,
      'ip': ip,
    });

    if (res == 'wrong') {
      emit(Delcubitfail(err: 'wrog'));
    } else {
      emit(Delcubitsuc(res: res));
    }
  }
}
