import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as zm;
import 'package:printing/printing.dart';

class cardsprinting extends StatefulWidget {
  static const name = 'cardsprint';
  const cardsprinting({Key? key}) : super(key: key);

  @override
  State<cardsprinting> createState() => _PrintingState();
}

class _PrintingState extends State<cardsprinting> {
  String? A;

  var focusNode = FocusNode();
  String? B;

  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;
    A = hh[0];
    B = hh[1];
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
                        onLayout: (format) => _generatePdf(format, A!, B!));
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
              Text(A!)
            ],
          ),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format, A!, B!),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String A, String B) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

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
                      pw.Text(
                        "اشتراك مخبز السيد طه",
                        style: pw.TextStyle(font: font, fontSize: 25),
                        textDirection: pw.TextDirection.rtl,
                      ),
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
                            pw.Text('$B جنيه',
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
              ));
        },
      ),
    );

    return pdf.save();
  }
}
