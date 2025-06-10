import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

part 'editcubit_state.dart';

class EditcubitCubit extends Cubit<EditcubitState> {
  EditcubitCubit() : super(EditcubitInitial());
  edit({ip, names, number, numbers, name, pass, per, day}) async {
    emit(Editcubitload());

    var res = await post(update, {
      'names': names,
      'number': number,
      'numbers': numbers.toString(),
      'name': name,
      'date': DateTime.now().toString(),
      'pro': 'edit$name' '' ' $names' '${numbers.toString()}',
      'ip': ip,
      'pass': pass,
      'per': per,
      'day': day,
      'id': ip,
    });

    if (res == 'wrong') {
      emit(Editcubitfail(err: 'wrong'));
    } else if (res["status"] == 'duplicate_pass') {
      emit(Editcubitfail(err: 'كلمة المرور مستخدمة من قبل'));
    } else {
      emit(Editcubitsuc(res: res));
    }
  }

  editcard({name, value}) async {
    emit(Editcubitload());

    var res = post(editcards, {
      'name': name,
      "value": value,
    });

    if (res == 'wrong') {
      emit(Editcubitfail(err: 'wrog'));
    } else {
      emit(Editcubitsuc(res: res));
    }
  }
}
