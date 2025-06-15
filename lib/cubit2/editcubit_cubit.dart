import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

part 'editcubit_state.dart';

class EditcubitCubit extends Cubit<EditcubitState> {
  EditcubitCubit() : super(EditcubitInitial());

  Future<void> edit({ip, names, number, numbers, name, pass, per, day}) async {
    try {
      emit(Editcubitload());

      if (ip == null || ip.toString().isEmpty) {
        emit(Editcubitfail(err: 'معرف المستخدم غير صالح'));
        return;
      }

      if (names == null || names.toString().isEmpty) {
        emit(Editcubitfail(err: 'الاسم مطلوب'));
        return;
      }

      if (number == null || number.toString().isEmpty) {
        emit(Editcubitfail(err: 'العدد مطلوب'));
        return;
      }

      if (per == 'باذن' && (pass == null || pass.toString().isEmpty)) {
        emit(Editcubitfail(err: 'كلمة المرور مطلوبة للإذن باذن'));
        return;
      }

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

      if (res["status"] == 'duplicate_pass') {
        emit(Editcubitfail(err: 'كلمة المرور مستخدمة من قبل'));
      } else {
        emit(Editcubitsuc(res: res));
      }
    } on NetworkException catch (e) {
      print('Network error: $e');
      emit(Editcubitfail(err: e.toString()));
    } on DataFormatException catch (e) {
      print('Data format error: $e');
      emit(Editcubitfail(err: e.toString()));
    } on ServerException catch (e) {
      print('Server error: $e');
      emit(Editcubitfail(err: e.toString()));
    } catch (e) {
      print('Unexpected error: $e');
      emit(Editcubitfail(err: e.toString()));
    }
  }

  Future<void> editcard({name, value}) async {
    try {
      emit(Editcubitload());

      if (name == null || name.toString().isEmpty) {
        emit(Editcubitfail(err: 'الاسم مطلوب'));
        return;
      }

      if (value == null || value.toString().isEmpty) {
        emit(Editcubitfail(err: 'القيمة مطلوبة'));
        return;
      }

      var res = await post(editcards, {
        'name': name,
        "value": value,
      });

      emit(Editcubitsuc(res: res));
    } on NetworkException catch (e) {
      print('Network error: $e');
      emit(Editcubitfail(err: e.toString()));
    } on DataFormatException catch (e) {
      print('Data format error: $e');
      emit(Editcubitfail(err: e.toString()));
    } on ServerException catch (e) {
      print('Server error: $e');
      emit(Editcubitfail(err: e.toString()));
    } catch (e) {
      print('Unexpected error: $e');
      emit(Editcubitfail(err: e.toString()));
    }
  }
}
