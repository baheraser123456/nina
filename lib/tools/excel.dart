import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createExcel() async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.getRangeByName('A1').setText('Hello World!');
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName =
      Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);
}
