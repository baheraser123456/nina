// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:printing/printing.dart' as zm;

class NoNamePrinting extends StatefulWidget {
  static const name = 'nonameprinting';
  const NoNamePrinting({Key? key}) : super(key: key);

  @override
  State<NoNamePrinting> createState() => _PrintingState();
}

class _PrintingState extends State<NoNamePrinting> {
  String? E;
  String? B;
  var focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;

    E = hh[0].toString();
    B = hh[1].toString();
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
                    zm.Printing.layoutPdf(
                        onLayout: (format) => _generatePdf(format, E!, B!));
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
              const Text('بدون اسم')
            ],
          ),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format, E!, B!),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String E, String B) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font =
        await fontFromAssetBundle('lib/assests/NotoSansArabic-Light.ttf');
    final fonts = await fontFromAssetBundle('lib/assests/EBGaramond-Bold.ttf');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Column(
                children: [
                  pw.Text(
                    B,
                    style: pw.TextStyle(font: font, fontSize: 20),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text(
                    'مخبز السيد طه',
                    style: pw.TextStyle(font: font, fontSize: 20),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 5),
                          child: pw.Text('$E رغيف',
                              style: pw.TextStyle(font: font, fontSize: 20),
                              textDirection: pw.TextDirection.rtl),
                        ),
                        pw.Text(
                          'العدد:',
                          style: pw.TextStyle(font: font, fontSize: 20),
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
