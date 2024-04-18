part of 'editcubit_cubit.dart';

abstract class EditcubitState {}

class EditcubitInitial extends EditcubitState {}

class Editcubitsuc extends EditcubitState {
  var res;
  Editcubitsuc({required this.res});
}

class Editcubitload extends EditcubitState {}

class Editcubitfail extends EditcubitState {
  String err;
  Editcubitfail({required this.err});
}
