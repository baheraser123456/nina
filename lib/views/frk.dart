import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/getcubit/get_cubit.dart';

import 'package:fina/views/frkprint.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../tools/button.dart';

class Frk extends StatefulWidget {
  const Frk({super.key});
  static const name = 'frk';
  @override
  State<Frk> createState() => _FrkState();
}

class _FrkState extends State<Frk> {
  bool _isLoading = false;
  String? _id;
  String? _name;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      _id = args['id'];
      _name = args['name'];
      if (_id != null) {
        context.read<DatacubitCubit>().getdatas(_id!);
      }
    });
  }

  void _refreshData() {
    if (_id != null) {
      context.read<DatacubitCubit>().getdatas(_id!);
    }
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

  Future<void> _handlePrint(String id, String breadDiff) async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Update frk and wait for success
      await context.read<DatacubitCubit>().updatefrk(id, breadDiff);
      
      if (!mounted) return;
      
      // Navigate to printing page
      final result = await Navigator.pushNamed(
        context,
        FrkPrinting.name,
        arguments: [_name, breadDiff, '0', id],
      );
      
      // Return to previous page with success
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Error updating bread difference: $e');
      if (mounted) {
        _showSnackBar('حدث خطأ أثناء التحديث');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: BlocConsumer<DatacubitCubit, DatacubitState>(
        listener: (context, state) {
          if (state is frksuc) {
            _showSnackBar('تم الصرف بنجاح');
          } else if (state is frkfail) {
            _showSnackBar('فشل الصرف');
            setState(() => _isLoading = false);
          } else if (state is Datacubitfail) {
            _showSnackBar(state.err);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('فرق العيش'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshData,
                ),
              ],
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(DatacubitState state) {
    if (state is Datacubitloading || state is frkload) {
      return _buildLoadingWidget();
    }

    if (state is Datacubitfail) {
      return _buildErrorWidget(state.err);
    }

    if (state is Datacubitsuc) {
      final data = state.data['data'];
      if (data == null || data.isEmpty) {
        return _buildErrorWidget('لا يوجد فرق عيش');
      }

      final breadDiff = data[0]['SUM(number)']?.toString() ?? '0';
      if (breadDiff == '0') {
        return _buildErrorWidget('لا يوجد فرق عيش');
      }

      return _buildDataWidget(data[0], _name ?? '', _id ?? '');
    }

    return _buildErrorWidget('حدث خطأ في النظام');
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري التحميل...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    IconData icon;
    String message;

    switch (error) {
      case 'خطأ في الاتصال بالشبكة':
        icon = Icons.wifi_off;
        message = 'لا يمكن الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت';
        break;
      case 'خطأ في تنسيق البيانات':
        icon = Icons.error_outline;
        message = 'حدث خطأ في تنسيق البيانات. يرجى المحاولة مرة أخرى';
        break;
      case 'خطأ في الخادم':
        icon = Icons.cloud_off;
        message = 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';
        break;
      case 'معرف المستخدم غير صالح':
        icon = Icons.person_off;
        message = 'معرف المستخدم غير صالح. يرجى المحاولة مرة أخرى';
        break;
      case 'لا يوجد فرق عيش':
        icon = Icons.check_circle_outline;
        message = 'لا يوجد فرق عيش لهذا المستخدم';
        break;
      default:
        icon = Icons.error_outline;
        message = error;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDataWidget(Map<String, dynamic> data, String name, String id) {
    final breadDiff = data['SUM(number)']?.toString() ?? '0';
    final unpaidAmount = data['SUM(bk)']?.toString() ?? '0';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'الاسم: $name',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.bakery_dining, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'فرق العيش: $breadDiff رغيف',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'المبلغ غير المدفوع: $unpaidAmount جنيه',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          custbutton(
            hint: _isLoading ? 'جاري الصرف...' : 'صرف',
            fun: _isLoading ? null : () => _handlePrint(id, breadDiff),
          ),
        ],
      ),
    );
  }
}
