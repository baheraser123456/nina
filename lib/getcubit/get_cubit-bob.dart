import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/html.dart';

class GetCubit extends Cubit<GetState> {
  GetCubit() : super(GetInitial());

  List<String?> gata = [];
  List<String?> cata = [];

  int? total;

  gets() async {
    gata.clear();
    cata.clear();
    var response = await getnames(geturl);
    for (var i = 0; i < response['data'].length; i++) {
      gata.add(response['data'][i]['name']);
    }
    var res = await getnames(getcards);
    for (var i = 0; i < res['data'].length; i++) {
      cata.add(res['data'][i]['name']);
    }
  }

  resets() {
    getnames(reset);
  }
}
