import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

part 'editcubit_state.dart';

class EditcubitCubit extends Cubit<EditcubitState> {
  EditcubitCubit() : super(EditcubitInitial());
  edit({ip, names, number, numbers, name}) async {
    emit(Editcubitload());

    var res = post(update, {
      'names': names,
      'number': number,
      'numbers': numbers.toString(),
      'name': name,
      'date': DateTime.now().toString(),
      'pro': 'edit$name' '' ' $names' '${numbers.toString()}',
      'ip': ip,
    });

    if (res == 'wrong') {
      emit(Editcubitfail(err: 'wrog'));
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
