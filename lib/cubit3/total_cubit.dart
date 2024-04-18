import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

part 'total_state.dart';

class TotalCubit extends Cubit<TotalState> {
  TotalCubit() : super(TotalInitial());

  gettotal() async {
    try {
      emit(Totalload());
      var data = await getnames(total);

      emit(Totalsuc(data: data));
      if (data == 'wrong') {
        emit(Totalfail());
      }
    } on Exception {
      emit(Totalfail());
    }
  }
}
