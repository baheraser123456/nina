part of 'datacubit_cubit.dart';

abstract class DatacubitState {}

class DatacubitInitial extends DatacubitState {}

class Datacubitloading extends DatacubitState {}

class Datacubitsuc extends DatacubitState {
  Datacubitsuc(this.data);
  Map data;
}

class Datacubitsucs extends DatacubitState {
  Datacubitsucs(this.zz, this.data);
  Map data;
  int zz;
}

class Datacubitfail extends DatacubitState {
  String err;
  Datacubitfail(this.err);
}

class Datacubitfails extends DatacubitState {
  String err;
  Datacubitfails(this.err);
}

class cardssuc extends DatacubitState {}

class cardsfail extends DatacubitState {}

class cardsload extends DatacubitState {}
