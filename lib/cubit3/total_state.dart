part of 'total_cubit.dart';

abstract class TotalState {}

class TotalInitial extends TotalState {}

class Totalsuc extends TotalState {
  var data;
  Totalsuc({required this.data});
}

class Totalload extends TotalState {}

class Totalfail extends TotalState {}
