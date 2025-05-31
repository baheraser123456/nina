import 'dart:typed_data';

import 'package:fina/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class cardsprinting extends StatefulWidget {
  static const name = 'cardsprint';
  const cardsprinting({Key? key}) : super(key: key);

  @override
  State<cardsprinting> createState() => _PrintingState();
}

class _PrintingState extends State<cardsprinting> {
    String? name;
  String? amount;
  String? month;

  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;
    name = hh[0];
    amount = hh[1];
    month = hh[2].toString();
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              RawKeyboardListener(
                autofocus: true,
                focusNode: focusNode,
                onKey: (event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                    Printing.layoutPdf(
                        onLayout: (format) => _generatePdf(format, name!, amount!, month!));
                  }
                },
                child: const Text(''),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(name!)
            ],
          ),
        ),
        body: PdfPreview(
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          allowPrinting: false,
          allowSharing: false,
          build: (format) => _generatePdf(format, name!, amount!, month!),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(FontAwesomeIcons.print),
          onPressed: () {
            Printing.layoutPdf(
              onLayout: (format) => _generatePdf(format, name!, amount!, month!),
            ).then((_) {
              Navigator.pop(context);
            });
          },
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String name, String amount, String month) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

    final font = await fontFromAssetBundle('lib/assests/NotoSansArabic-Light.ttf');
    final fonts = await fontFromAssetBundle('lib/assests/EBGaramond-Bold.ttf');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Column(
                children: [
                  pw.Text(
                    "اشتراك شهر $month $forn_name",
                    style: pw.TextStyle(font: font, fontSize: 25),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(name,
                            style: pw.TextStyle(font: font, fontSize: 15),
                            textDirection: pw.TextDirection.rtl),
                        pw.Text(
                          'الاسم:',
                          style: pw.TextStyle(font: font, fontSize: 15),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('$amount جنيه',
                            style: pw.TextStyle(font: font, fontSize: 20),
                            textDirection: pw.TextDirection.rtl),
                        pw.Text(
                          'تم دفع اشتراك بقيمة:',
                          style: pw.TextStyle(font: font, fontSize: 15),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ]),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(DateFormat.yMd().add_jm().format(DateTime.now()),
                      style: pw.TextStyle(
                        font: fonts,
                        fontSize: 10,
                      ),
                      textDirection: pw.TextDirection.rtl),
                  pw.SizedBox(height: 10),
                ],
              )
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
