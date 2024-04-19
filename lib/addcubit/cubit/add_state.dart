part of 'add_cubit.dart';

abstract class AddState {}

class Initialadd extends AddState {}

class Sucadd extends AddState {}

class Failadd extends AddState {
  String txt;
  Failadd({required this.txt});
}

class Sucaddion extends AddState {}

class Failaddion extends AddState {}
