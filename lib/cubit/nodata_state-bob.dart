part of 'nodata_cubit.dart';

abstract class NodataState {}

class NodataInitial extends NodataState {}

class Nodatasuc extends NodataState {
  final List hh;
  Nodatasuc(this.hh);
}

class Nodatafail extends NodataState {}

class Nodataloading extends NodataState {}
