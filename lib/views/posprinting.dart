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

class posorinting extends StatefulWidget {
  static const name = 'posprinting';
  const posorinting({Key? key}) : super(key: key);

  @override
  State<posorinting> createState() => _PrintingState();
}

class _PrintingState extends State<posorinting> {
  String? E;
  String? B;
  String? C;
  var focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;

    E = hh[0].toString();
    B = hh[1].toString();
    C = hh[2].toString();
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
                        onLayout: (format) => _generatePdf(format, E!, B!, C!));
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
              const Text("توزيع")
            ],
          ),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format, E!, B!, C!),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String E, String B, String C) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

    final fonts = await fontFromAssetBundle('lib/assests/EBGaramond-Bold.ttf');
    final ByteData fontData =
        await rootBundle.load("lib/assests/alfont_com_arial-1.ttf");
    final ttf = pw.Font.ttf(fontData);

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
                    "تـــوزيع $C",
                    style: pw.TextStyle(font: ttf, fontSize: 20),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'مخبز السيد طه',
                    style: pw.TextStyle(font: ttf, fontSize: 20),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 5),
                          child: pw.Text(E,
                              style: pw.TextStyle(font: ttf, fontSize: 20),
                              textDirection: pw.TextDirection.rtl),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'الاسم:',
                          style: pw.TextStyle(font: ttf, fontSize: 20),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ]),
                  pw.SizedBox(height: 10),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 5),
                          child: pw.Text('$B رغيف',
                              style: pw.TextStyle(font: ttf, fontSize: 20),
                              textDirection: pw.TextDirection.rtl),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'العدد:',
                          style: pw.TextStyle(font: ttf, fontSize: 20),
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
