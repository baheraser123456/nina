import 'package:cubit_form/cubit_form.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:flutter/material.dart';

class history extends StatelessWidget {
  const history({super.key});
  static const name = 'his';

  @override
  Widget build(BuildContext context) {
    String ip = ModalRoute.of(context)!.settings.arguments.toString();
    BlocProvider.of<DatacubitCubit>(context).gethis(ip);

    return BlocBuilder<DatacubitCubit, DatacubitState>(
      builder: (context, state) => state is Datacubitsuc
          ? Scaffold(
              appBar: AppBar(),
              body: ListView.builder(
                reverse: false,
                itemBuilder: ((context, index) => _createDataTable(
                    context: context,
                    A: state.data['data'][index]['ip'].toString(),
                    B: state.data['data'][index]['name'].toString(),
                    C: state.data['data'][index]['pro'].toString(),
                    D: state.data['data'][index]['date'].toString(),
                    E: state.data['data'][index]['operation'].toString())),
                itemCount: state.data['data'].length,
              ),
            )
          : state is Datacubitfail
              ? Scaffold(
                  appBar: AppBar(),
                  body: const Center(
                    child: Text('هناك خطأ في الشبكة حاول مرة اخري'),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
    );
  }
}

DataTable _createDataTable({
  required BuildContext context,
  required A,
  required B,
  required C,
  required D,
  required E,
}) {
  return DataTable(
      columns: _createColumns(),
      rows: _createRows(context: context, A: A, B: B, C: C, D: D, E: E));
}

List<DataColumn> _createColumns() {
  return [
    const DataColumn(label: Text('الكود')),
    const DataColumn(label: Text('نوع العملية')),
    const DataColumn(label: Text('العملية')),
    const DataColumn(label: Text('تاريخ ')),
  ];
}

List<DataRow> _createRows({
  required BuildContext context,
  required A,
  required B,
  required C,
  required D,
  required E,
}) {
  String originalName = B.toString();
  String originalPro = C.toString();

  String displayedName;
  String displayedPro;

  if (originalPro == 'فرق العيش' ) {
    displayedName = originalPro;
    displayedPro = originalName;
  } else if (originalName=='اضافة عيش'){
        displayedName = 'اضافة عيش';
    displayedPro = originalPro;

  }else{
    displayedName = 'سحب';
    displayedPro = originalPro;
  }

  return [
    DataRow(cells: [
      DataCell(Text(A.toString())),
      DataCell(Text(displayedName)),
      DataCell(Text(displayedPro)),
      DataCell(Text(D.toString())),
    ]),
  ];
}
