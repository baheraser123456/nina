import 'package:bloc/bloc.dart';
import 'package:fina/constants.dart';
import 'package:fina/html.dart';
import 'package:meta/meta.dart';

part 'nodata_state.dart';

class NodataCubit extends Cubit<NodataState> {
  NodataCubit() : super(NodataInitial());
  nodata(now) async {
    emit(Nodataloading());
    var res = await post(nodataurl, {
      'totals': now.toString(),
      'total': DateTime.now().day.toString(),
      'date': DateTime.now().toString(),
      'pro': now.toString()
    });
    print(res);

    if (res == 'wrong') {
      emit(Nodatafail());
    } else {
      List hh = [now, res['data'][0]['id']];
      emit(Nodatasuc(hh));
    }
  }

  nodatas(now) async {
    emit(Nodataloading());
    var res = await post(nodatasurl, {
      'totals': now.toString(),
      'total': DateTime.now().day.toString(),
      'date': DateTime.now().toString(),
      'pro': now.toString()
    });

    if (res == 'wrong') {
      emit(Nodatafail());
    } else {
      List hh = [now, res['data'][0]['id']];
      emit(Nodatasuc(hh));
    }
  }

  pos(name, nums, place) async {
    emit(Nodataloading());
    var res = await post(Pos, {
      "name": name,
      'date': DateTime.now().toString(),
      "ip": nums.toString(),
    });

    if (res == 'wrong') {
      emit(Nodatafail());
    } else {
      List hh = [name, nums, place];
      emit(Nodatasuc(hh));
    }
  }
}
