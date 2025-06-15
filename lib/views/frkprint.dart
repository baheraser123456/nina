// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:fina/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FrkPrinting extends StatefulWidget {
  const FrkPrinting({super.key});
  static const name = 'frkprint';

  @override
  State<FrkPrinting> createState() => _FrkPrintingState();
}

class _FrkPrintingState extends State<FrkPrinting> {
  bool _isLoading = false;
  String? _error;
  String _title = 'فرق العيش';
  String _bakeryName = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _title = prefs.getString('frk_title') ?? 'فرق العيش';
      _bakeryName = forn_name;
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _printDocument() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      final name = args[0] as String;
      final number = args[1] as String;
      final bk = args[2] as String;
      final id = args[3] as String;

      if (number == '0') {
        throw Exception('لا يوجد فرق عيش للطباعة');
      }

      await Printing.layoutPdf(
        onLayout: (format) => _generatePdf(format, name, number, bk, id),
      ).then((_) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      print('Error printing document: $e');
      setState(() => _error = e.toString().contains('لا يوجد فرق عيش') 
          ? 'لا يوجد فرق عيش للطباعة' 
          : 'حدث خطأ أثناء الطباعة');
      _showSnackBar(_error!);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String name, String number, String bk, String id) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

    final fonts = await fontFromAssetBundle('lib/assests/EBGaramond-Bold.ttf');
    final ByteData fontData = await rootBundle.load("lib/assests/alfont_com_arial-1.ttf");
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
                        pw.Text(
                          name,
                          style: pw.TextStyle(font: ttf, fontSize: 15),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.Text(
                          'الاسم:',
                          style: pw.TextStyle(font: font, fontSize: 15),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          '$number رغيف',
                          style: pw.TextStyle(font: font, fontSize: 20),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.Text(
                          'عدد الأرغفة:',
                          style: pw.TextStyle(font: font, fontSize: 15),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          '$bk جنيه',
                          style: pw.TextStyle(font: font, fontSize: 20),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.Text(
                          'المبلغ غير المدفوع:',
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
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طباعة الفرق'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: PdfPreview(
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowPrinting: false,
              allowSharing: false,
              build: (format) => _generatePdf(
                format,
                (ModalRoute.of(context)!.settings.arguments as List<dynamic>)[0] as String,
                (ModalRoute.of(context)!.settings.arguments as List<dynamic>)[1] as String,
                (ModalRoute.of(context)!.settings.arguments as List<dynamic>)[2] as String,
                (ModalRoute.of(context)!.settings.arguments as List<dynamic>)[3] as String,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _printDocument,
        label: Text(_isLoading ? 'جاري الطباعة...' : 'طباعة'),
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.print),
      ),
    );
  }
}
