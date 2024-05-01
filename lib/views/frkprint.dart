// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FrkPrinting extends StatefulWidget {
  static const name = 'frkprint';
  const FrkPrinting({Key? key}) : super(key: key);

  @override
  State<FrkPrinting> createState() => _FrkPrintingState();
}

class _FrkPrintingState extends State<FrkPrinting> {
  String? A;

  String? B;

  String? E;
  String? R;

  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;

    A = hh[0];
    B = hh[1].toString();

    R = hh[2].toString();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(A!)
            ],
          ),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format, A!, B!, R!),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String A, String B, String R) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    final fonts = await fontFromAssetBundle('lib/assests/EBGaramond-Bold.ttf');
    final ByteData fontData =
        await rootBundle.load("lib/assests/alfont_com_arial-1.ttf");
    final ttf = pw.Font.ttf(fontData);
    final font = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Padding(
              padding: const pw.EdgeInsets.only(left: 20),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Column(
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(A,
                                style: pw.TextStyle(font: ttf, fontSize: 15),
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
                            pw.Text('$B رغيف',
                                style: pw.TextStyle(font: font, fontSize: 10),
                                textDirection: pw.TextDirection.rtl),
                            pw.Text(
                              'العدد:',
                              style: pw.TextStyle(font: font, fontSize: 15),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text('${int.parse(R) * -1} جنيه ',
                                style: pw.TextStyle(font: font, fontSize: 10),
                                textDirection: pw.TextDirection.rtl),
                            pw.Text('مبلغ غير مدفوع: ',
                                style: pw.TextStyle(font: font, fontSize: 15),
                                textDirection: pw.TextDirection.rtl),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                                '${(int.parse(B) * 0.35).toStringAsFixed(2)} جنيه ',
                                style: pw.TextStyle(font: font, fontSize: 10),
                                textDirection: pw.TextDirection.rtl),
                            pw.Text('فرق العيش: ',
                                style: pw.TextStyle(font: font, fontSize: 15),
                                textDirection: pw.TextDirection.rtl),
                          ])
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
              ));
        },
      ),
    );

    return pdf.save();
  }
}
