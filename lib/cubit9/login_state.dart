part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class Loginloading extends LoginState {}

class Loginsuc extends LoginState {}

class Loginfail extends LoginState {}
