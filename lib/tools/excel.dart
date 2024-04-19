import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createExcel(List data, int mon) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.getRangeByName('A1').setText('الاسم');
  sheet.getRangeByName('B1').setText("المكان");
  sheet.getRangeByName('C1').setText('المبلغ المستحق');
  for (int i = 0; i < data.length; i++) {
    sheet.getRangeByName('A${i + 2}').setText(data[i]['name']);
    sheet.getRangeByName('B${i + 2}').setText(data[i]['place']);
    sheet.getRangeByName('C${i + 2}').setText(data[i]['value'].toString());
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName =
      Platform.isWindows ? '$path\\$mon.xlsx' : '$path/Output.xlsx';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open(fileName);
}
