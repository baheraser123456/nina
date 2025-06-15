import 'package:flutter/material.dart';
import 'package:fina/tools/button.dart';
import 'package:fina/tools/datadatafilter.dart';
import 'package:fina/tools/deligate.dart';
import 'package:fina/views/add.dart';
import 'package:fina/views/add_cards.dart';
import 'package:fina/views/bloc.dart';
import 'package:fina/views/chm.dart';
import 'package:fina/views/cm.dart';
import 'package:fina/views/day.dart';
import 'package:fina/views/deldeli.dart';
import 'package:fina/views/deletefilter.dart';
import 'package:fina/views/deli.dart';
import 'package:fina/views/dfdeli.dart';
import 'package:fina/views/dftotal.dart';
import 'package:fina/views/dis.dart';
import 'package:fina/views/editall.dart';
import 'package:fina/views/editmonfilter.dart';
import 'package:fina/views/frkdeli.dart';
import 'package:fina/views/M.dart';
import 'package:fina/views/M2024.dart';
import 'package:fina/views/nonamedata.dart';
import 'package:fina/views/outing.dart';
import 'package:fina/views/outingtotal.dart';
import 'package:fina/views/per.dart';
import 'package:fina/views/refactory.dart';
import 'package:fina/views/total.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fina/constants.dart';
import 'package:fina/views/home.dart';
import 'package:fina/views/settings.dart';

class SplashPage extends StatefulWidget {
  static const name = 'splash';
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final bakeryName = prefs.getString('bakery_name');
    final breadType = prefs.getString('bread_type');

    if (bakeryName != null) {
      forn_name = bakeryName;
    }
    if (breadType != null) {
      // Update bread type in constants if needed
    }

    // Navigate to home page after loading settings
    if (mounted) {
      Navigator.pushReplacementNamed(context, SplashScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SplashScreen  extends StatelessWidget {
  const SplashScreen ({super.key});
  static String name = 'splash';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                _buildButtonGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonGrid(BuildContext context) {
    final buttons = [
      _ButtonConfig("استعلام", () => _showSearch(context, datafilter())),
      _ButtonConfig("تعديل اخر عملية", () => _showSearch(context, datafilterss())),
      _ButtonConfig("خارجي", () => Navigator.pushNamed(context, outing.name)),
      _ButtonConfig("بدون اسم", () => Navigator.pushNamed(context, hhhh.name)),
      _ButtonConfig("اضافة", () => Navigator.pushNamed(context, add.name)),
      _ButtonConfig("تعديل", () => _showSearch(context, datafilters())),
      _ButtonConfig("اجمالي الخارجي", () => Navigator.pushNamed(context, OutTotal.name)),
      _ButtonConfig("الاجمالي", () => Navigator.pushNamed(context, Total.name)),
      _ButtonConfig("تعديل الكل", () => Navigator.pushNamed(context, EditAll.name)),
      _ButtonConfig("اعادة الضبط", () => Navigator.pushNamed(context, refactor.name)),
      _ButtonConfig("حظر", () => _showSearch(context, datafilterblock())),
      _ButtonConfig("حذف", () => _showSearch(context, delfilter())),
      _ButtonConfig("التوزيع", () => _showSearch(context, disdeli())),
      _ButtonConfig("الاشتراكات", () => Navigator.pushNamed(context, Month.name)),
      _ButtonConfig("دفع", () => _showSearch(context, dfdeli())),
      _ButtonConfig("اجمالي الاشتراكات", () => Navigator.pushNamed(context, dfTotal.name)),
      _ButtonConfig("اجمالي اشتراكات التوزيع", () => Navigator.pushNamed(context, dfTotal.name)),
      _ButtonConfig("اضافة للتوزيع", () => Navigator.pushNamed(context, Addcard.name)),
      _ButtonConfig("طباعة", () => Navigator.pushNamed(context, ChMonth.name)),
      _ButtonConfig("حذف من التوزيع", () => _showSearch(context, DeleteFilter())),
      _ButtonConfig("تعديل الاشتراك", () => _showSearch(context, mondeli())),
      _ButtonConfig("اشتراكات 2024", () => Navigator.pushNamed(context, Month2024.name)),
      _ButtonConfig("2024 طباعة", () => Navigator.pushNamed(context, ChMonth2024.name)),
      _ButtonConfig("الإعدادات", () => Navigator.pushNamed(context, SettingsPage.name)),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: buttons.map((config) => _buildButton(config)).toList(),
    );
  }

  Widget _buildButton(_ButtonConfig config) {
    return custbutton(
      hint: config.label,
      fun: config.onPressed,
    );
  }

  void _showSearch(BuildContext context, dynamic delegate) {
    showSearch(
      context: context,
      delegate: delegate,
    );
  }
}

class _ButtonConfig {
  final String label;
  final VoidCallback onPressed;

  _ButtonConfig(this.label, this.onPressed);
}
