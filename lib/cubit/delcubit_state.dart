part of 'delcubit_cubit.dart';

abstract class DelcubitState {}

class DelcubitInitial extends DelcubitState {}

class Delcubitsuc extends DelcubitState {
  var res;
  Delcubitsuc({required this.res});
}

class Delcubitload extends DelcubitState {}

class Delcubitfail extends DelcubitState {
  String err;
  Delcubitfail({required this.err});
}
