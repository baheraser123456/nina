import 'dart:typed_data';

import 'package:fina/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as zm;
import 'package:printing/printing.dart';

class Printing extends StatefulWidget {
  static const name = 'print';
  const Printing({super.key});

  @override
  State<Printing> createState() => _PrintingState();
}

class _PrintingState extends State<Printing> {
  String? A;
  String? C;
  String? B;
  String? D;
  String? E;
  var focusNode = FocusNode();
  String _title = 'خبز';
  String _breadType = 'خبز';
  String _bakeryName = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _title = prefs.getString('regular_title') ?? 'خبز';
      _breadType = prefs.getString('bread_type') ?? 'خبز';
      _bakeryName =  forn_name;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List hh = ModalRoute.of(context)!.settings.arguments as List;

    A = hh[0];
    B = hh[3].toString();
    C = hh[1].toString();
    D = hh[2].toString();
    E = hh[4].toString();

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
                        onLayout: (format) =>
                            _generatePdf(format, A!, C!, B!, D!, E!)).then((_) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: const Text(''),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 1);
                },
              ),
              Text(A!)
            ],
          ),
        ),
        body: PdfPreview(
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          allowPrinting: false,
          allowSharing: false,
          build: (format) => _generatePdf(format, A!, C!, B!, D!, E!),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(FontAwesomeIcons.print),
          onPressed: () {
            zm.Printing.layoutPdf(
              onLayout: (format) => _generatePdf(format, A!, C!, B!, D!, E!),
            ).then((_) {
              Navigator.pop(context);
            });
          },
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String A, String B,
      String C, String D, String E) async {
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
                      _title,
                      style: pw.TextStyle(font: font, fontSize: 25),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.Text(
                      _bakeryName,
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
                          pw.Text('$B $_breadType',
                              style: pw.TextStyle(font: font, fontSize: 20),
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
                          pw.Text('$D $_breadType',
                              style: pw.TextStyle(font: font, fontSize: 10),
                              textDirection: pw.TextDirection.rtl),
                          pw.Text(' المتبقي: ',
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
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
