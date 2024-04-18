import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vheck_state.dart';

class VheckCubit extends Cubit<VheckState> {
  VheckCubit() : super(check());
  onchanged() {
    emit(check());
  }
}
