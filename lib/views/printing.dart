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
    try {
      print('Printing page build started');
      final List<dynamic> hh = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      print('Received arguments: $hh');
      
      if (hh.length < 5) {
        print('Invalid arguments length: ${hh.length}');
        return Scaffold(
          appBar: AppBar(
            title: const Text('خطأ'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: const Center(
            child: Text('بيانات غير صحيحة'),
          ),
        );
      }

      A = hh[0].toString();
      B = hh[3].toString();
      C = hh[1].toString();
      D = hh[2].toString();
      E = hh[4].toString();

      print('Processed data:');
      print('A (name): $A');
      print('B (id): $B');
      print('C (number): $C');
      print('D (numbers): $D');
      print('E (date): $E');

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
                      print('Enter key pressed, generating PDF...');
                      zm.Printing.layoutPdf(
                          onLayout: (format) =>
                              _generatePdf(format, A!, C!, B!, D!, E!)).then((_) {
                        print('PDF generated successfully');
                        Navigator.pop(context);
                      }).catchError((error) {
                        print('Error generating PDF: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ أثناء الطباعة: $error')),
                        );
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
            build: (format) {
              print('Building PDF preview...');
              return _generatePdf(format, A!, C!, B!, D!, E!);
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(FontAwesomeIcons.print),
            onPressed: () {
              print('Print button pressed, generating PDF...');
              zm.Printing.layoutPdf(
                onLayout: (format) => _generatePdf(format, A!, C!, B!, D!, E!),
              ).then((_) {
                print('PDF generated successfully');
                Navigator.pop(context);
              }).catchError((error) {
                print('Error generating PDF: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('حدث خطأ أثناء الطباعة: $error')),
                );
              });
            },
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error in printing page: $e');
      print('Stack trace: $stackTrace');
      return Scaffold(
        appBar: AppBar(
          title: const Text('خطأ'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('حدث خطأ أثناء تحميل الصفحة'),
              const SizedBox(height: 16),
              Text('التفاصيل: $e', style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String A, String B,
      String C, String D, String E) async {
    print('Starting PDF generation...');
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

    try {
      print('Loading fonts...');
      final ByteData fontData = await rootBundle.load("lib/assests/alfont_com_arial-1.ttf");
      final ByteData garamondFontData = await rootBundle.load("lib/assests/EBGaramond-Bold.ttf");
      final ByteData arabicFontData = await rootBundle.load("lib/assests/NotoSansArabic-Light.ttf");
      final ttf = pw.Font.ttf(fontData);
      final garamondFont = pw.Font.ttf(garamondFontData);
      final arabicFont = pw.Font.ttf(arabicFontData);
      print('Fonts loaded successfully');

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) {
            print('Building PDF page...');
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
                        style: pw.TextStyle(font: arabicFont, fontSize: 25),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        _bakeryName,
                        style: pw.TextStyle(font: arabicFont, fontSize: 25),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(A,
                                style: pw.TextStyle(font: arabicFont, fontSize: 15),
                                textDirection: pw.TextDirection.rtl),
                            pw.Text(
                              'الاسم:',
                              style: pw.TextStyle(font: arabicFont, fontSize: 15),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text('$B $_breadType',
                                style: pw.TextStyle(font: arabicFont, fontSize: 20),
                                textDirection: pw.TextDirection.rtl),
                            pw.Text(
                              'العدد:',
                              style: pw.TextStyle(font: arabicFont, fontSize: 15),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text('$D $_breadType',
                                style: pw.TextStyle(font: arabicFont, fontSize: 10),
                                textDirection: pw.TextDirection.rtl),
                            pw.Text(' المتبقي: ',
                                style: pw.TextStyle(font: arabicFont, fontSize: 15),
                                textDirection: pw.TextDirection.rtl),
                          ])
                    ],
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(DateFormat.yMd().add_jm().format(DateTime.now()),
                          style: pw.TextStyle(
                            font: garamondFont,
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

      print('Saving PDF...');
      final result = await pdf.save();
      print('PDF saved successfully');
      return result;
    } catch (e, stackTrace) {
      print('Error generating PDF: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
