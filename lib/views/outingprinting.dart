// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:printing/printing.dart' as zm;

class outingprinting extends StatefulWidget {
  static const name = 'outingprints';
  const outingprinting({Key? key}) : super(key: key);

  @override
  State<outingprinting> createState() => _PrintingState();
}

class _PrintingState extends State<outingprinting> {
  String? e;
  var focusNode = FocusNode();
  String? b;
  String _title = 'خارجي';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _title = prefs.getString('outing_title') ?? 'خارجي';
    });
  }

  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;

    e = (hh[0].toInt()).toString();
    b = hh[1].toString();

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
                      onLayout: (format) => _generatePdf(format, e!, b!),
                    ).then((_) {
                      Navigator.pop(context); // الخروج بعد الطباعة
                    });
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
              const Text('طباعة')
            ],
          ),
        ),
        body: PdfPreview(
          // يمنع تغيير الصفحة
          canChangeOrientation: false, // يمنع تغيير الاتجاه
          canChangePageFormat: false,  // يخفي خيار اختيار حجم الورق
          canDebug: false,  // يخفي زر التصحيح
          allowPrinting: false,
          allowSharing: false,
          build: (format) => _generatePdf(format, e!, b!),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(FontAwesomeIcons.print),
          onPressed: () {
            zm.Printing.layoutPdf(
              onLayout: (format) => _generatePdf(format, e!, b!),
            ).then((_) {
              Navigator.pop(context); // الخروج بعد الطباعة مباشرةً
            });
          },
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String e, String b) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
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
                    _title,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      font: font,
                      fontSize: 25,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text(
                    b,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      font: font,
                      fontSize: 25,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text(
                    'خبـــز',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      font: font,
                      fontSize: 25,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        '$e رغيف',
                        style: pw.TextStyle(font: font, fontSize: 15),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'العدد:',
                        style: pw.TextStyle(font: font, fontSize: 15),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ],
                  ),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    DateFormat.yMd().add_jm().format(DateTime.now()),
                    style: pw.TextStyle(
                      font: fonts,
                      fontSize: 10,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
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
