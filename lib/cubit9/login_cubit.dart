import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  logins(email, pass) async {
    emit(Loginloading());
    var respone = await post(login, {'email': email, 'pass': pass});

    if (respone['stutas'] == 'success') {
      emit(Loginsuc());
    } else if (respone["stutas"] == "fail" || respone == 'wrong') {
      emit(Loginfail());
    }
  }
}
