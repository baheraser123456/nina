import 'package:bloc/bloc.dart';

import 'package:fina/class.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';

part 'get_state.dart';

class GetCubit extends Cubit<GetState> {
  GetCubit() : super(GetInitial());

  List<String?> gata = [];
  List<String?> cata = [];
  List<Data?> frk = [];

  int? total;

  gets() async {
    gata.clear();
    cata.clear();
    frk.clear();
    var response = await getnames(geturl);
    for (var i = 0; i < response['data'].length; i++) {
      gata.add(response['data'][i]['name']);
    }
    var res = await getnames(getcards);
    for (var i = 0; i < res['data'].length; i++) {
      cata.add(res['data'][i]['name']);
    }
    var respons = await getnames(frks);
    for (var i = 0; i < respons['data'].length; i++) {
      frk.add(Data(
          name: respons['data'][i]['name'],
          id: respons['data'][i]['id'].toString()));
    }
  }

  resets() {
    getnames(reset);
  }
}
