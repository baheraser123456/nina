import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const name = 'settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _regularTitleController = TextEditingController();
  final TextEditingController _outingTitleController = TextEditingController();
  final TextEditingController _noNameTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _regularTitleController.dispose();
    _outingTitleController.dispose();
    _noNameTitleController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _regularTitleController.text = prefs.getString('regular_title') ?? 'خبز';
      _outingTitleController.text = prefs.getString('outing_title') ?? 'خارجي';
      _noNameTitleController.text = prefs.getString('no_name_title') ?? 'بدون اسم';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('regular_title', _regularTitleController.text);
    await prefs.setString('outing_title', _outingTitleController.text);
    await prefs.setString('no_name_title', _noNameTitleController.text);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الإعدادات')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _regularTitleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الطباعة العادية',
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _outingTitleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الطباعة الخارجية',
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noNameTitleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الطباعة بدون اسم',
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('حفظ الإعدادات'),
            ),
          ],
        ),
      ),
    );
  }
}