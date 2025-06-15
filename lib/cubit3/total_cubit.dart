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

      if (data == 'wrong') {
        emit(Totalfail());
        return;
      }

      emit(Totalsuc(data: data));
    } on FormatException catch (e) {
      print('Data format error: $e');
      emit(Totalfail());
    } on Exception catch (e) {
      print('Unexpected error: $e');
      emit(Totalfail());
    }
  }
}
