import 'package:fina/cubit2/editcubit_cubit.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Edit extends StatefulWidget {
  static const name = 'Edit';
  
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late final TextEditingController _nameController;
  late final TextEditingController _numbersController;
  late final TextEditingController _idController;
  late final TextEditingController _passController;
  final _formKey = GlobalKey<FormState>();
  String _permissionValue = 'باذن';
  String _dayTypeValue = 'يومي';
  String? _userId;
  Map<String, dynamic>? _userData;
  bool _isVerified = false;
  bool _isLoading = false;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        duration: Duration(seconds: isError ? 3 : 2),
        action: isError ? SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ) : null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchInitialData());
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _numbersController = TextEditingController();
    _idController = TextEditingController();
    _passController = TextEditingController();
  }

  void _fetchInitialData() {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is String) {
      _userId = routeArgs;
      context.read<DatacubitCubit>().getdata(_userId!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numbersController.dispose();
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatacubitCubit, DatacubitState>(
      listener: (context, state) {
        if (state is Datacubitsuc) {
          _userData = state.data['data'][0];
          if (!_isVerified && _userData?['per'] == 'باذن') {
            _verifyPasswordBeforeShow();
          } else {
            _populateFormData(_userData!);
          }
        } else if (state is Datacubitfail) {
          _showSnackBar(state.err, isError: true);
        }
      },
      builder: (context, state) {
        if (state is Datacubitsuc) {
          if (_userData?['per'] == 'باذن' && !_isVerified) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return _buildEditForm();
        }
        if (state is Datacubitloading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('هناك خطا في الشبكة')),
        );
      },
    );
  }

  Future<void> _verifyPasswordBeforeShow() async {
    if (_userData == null) return;
    
    final passwordController = TextEditingController();
    final enteredPassword = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد كلمة المرور'),
        content: TextField(
          controller: passwordController,
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            hintText: 'أدخل كلمة المرور',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('تأكيد'),
            onPressed: () {
              if (passwordController.text.isEmpty) {
                _showSnackBar('كلمة المرور مطلوبة', isError: true);
                return;
              }
              Navigator.of(context).pop(passwordController.text);
            },
          ),
        ],
      ),
    );
    
    if (enteredPassword == null) {
      Navigator.pop(context);
      return;
    }
    
    if (enteredPassword != (_userData?['pass']?.toString() ?? _userData?['id']?.toString() ?? '')) {
      _showSnackBar('كلمة المرور غير صحيحة', isError: true);
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isVerified = true;
      _populateFormData(_userData!);
    });
  }

  void _populateFormData(Map<String, dynamic> data) {
    if (!mounted) return;
    setState(() {
      _nameController.text = data['name']?.toString() ?? '';
      _numbersController.text = data['numbers']?.toString() ?? '';
      _idController.text = data['id']?.toString() ?? '';
      _passController.text = data['pass']?.toString() ?? '';
      _permissionValue = data['per']?.toString() ?? 'باذن';
      _dayTypeValue = data['day']?.toString() ?? 'يومي';
    });
  }

  Widget _buildEditForm() {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل البيانات')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildIdField(),
            const SizedBox(height: 20),
            _buildNameField(),
            const SizedBox(height: 20),
            _buildNumberOfPeopleField(),
            const SizedBox(height: 20),
            if (_permissionValue == 'باذن') _buildPasswordField(),
            const SizedBox(height: 20),
            _buildPermissionDropdown(),
            const SizedBox(height: 20),
            _buildDayTypeDropdown(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIdField() => TextFormField(
    controller: _idController,
    enabled: false,
    decoration: const InputDecoration(
      labelText: 'الكود',
      border: OutlineInputBorder(),
    ),
  );

  Widget _buildNameField() => TextFormField(
    controller: _nameController,
    decoration: const InputDecoration(
      labelText: 'الاسم',
      border: OutlineInputBorder(),
    ),
    validator: (value) => value?.isEmpty ?? true ? 'الاسم مطلوب' : null,
  );

  Widget _buildNumberOfPeopleField() => TextFormField(
    controller: _numbersController,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: const InputDecoration(
      labelText: 'عدد الأفراد',
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value?.isEmpty ?? true) return 'عدد الأفراد مطلوب';
      return null;
    },
  );

  Widget _buildPasswordField() => TextFormField(
    controller: _passController,
    obscureText: false,
    maxLength: 4,
    decoration: const InputDecoration(
      labelText: 'كلمة المرور',
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value?.isEmpty ?? true) {
        return 'كلمة المرور مطلوبة للإذن باذن';
      }
      if (value?.length != 4) {
        return 'كلمة المرور يجب أن تكون 4 أرقام';
      }
      if (!RegExp(r'^\d{4}$').hasMatch(value!)) {
        return 'كلمة المرور يجب أن تكون أرقام فقط';
      }
      return null;
    },
  );

  Widget _buildPermissionDropdown() => DropdownButtonFormField<String>(
    value: _permissionValue,
    decoration: const InputDecoration(
      labelText: 'نوع الإذن',
      border: OutlineInputBorder(),
    ),
    items: const [
      DropdownMenuItem(value: 'باذن', child: Text('باذن')),
      DropdownMenuItem(value: 'بدون اذن', child: Text('بدون اذن')),
    ],
    onChanged: (val) {
      if (val != null) {
        setState(() {
          _permissionValue = val;
          // Clear password when changing to non-bاذن
          if (val != 'باذن') {
            _passController.clear();
          }
        });
      }
    },
  );

  Widget _buildDayTypeDropdown() => DropdownButtonFormField<String>(
    value: _dayTypeValue,
    decoration: const InputDecoration(
      labelText: 'نوع الصرف',
      border: OutlineInputBorder(),
    ),
    items: const [
      DropdownMenuItem(value: 'يومي', child: Text('يومي')),
      DropdownMenuItem(value: 'غير', child: Text('غير')),
    ],
    onChanged: (val) => val != null 
        ? setState(() => _dayTypeValue = val)
        : null,
  );

  Widget _buildSubmitButton() {
    return BlocConsumer<EditcubitCubit, EditcubitState>(
      listener: (context, state) {
        if (state is Editcubitfail) {
          setState(() => _isLoading = false);
          _showSnackBar(state.err, isError: true);
        } else if (state is Editcubitsuc) {
          setState(() => _isLoading = false);
          _showSnackBar('تم التحديث بنجاح');
          Navigator.pop(context);
          context.read<GetCubit>().gets();
        } else if (state is Editcubitload) {
          setState(() => _isLoading = true);
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _handleFormSubmission(context),
            child: _isLoading 
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('تعديل'),
          ),
        );
      },
    );
  }

  Future<void> _handleFormSubmission(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_userData == null) return;

    // Check if anything has changed
    final bool hasNameChanged = _nameController.text != _userData!['name']?.toString();
    final bool hasNumbersChanged = _numbersController.text != _userData!['numbers']?.toString();
    final bool hasPermissionChanged = _permissionValue != _userData!['per']?.toString();
    final bool hasDayTypeChanged = _dayTypeValue != _userData!['day']?.toString();
    
    // Check if current password is '0000' to allow arbitrary changes
    final bool isDefaultPassword = _userData!['pass']?.toString() == '0000';
    final bool hasPasswordChanged = _permissionValue == 'باذن' && 
        _passController.text.isNotEmpty && 
        (isDefaultPassword || _passController.text != _userData!['pass']?.toString());

    // If nothing has changed, show message and return
    if (!hasNameChanged && !hasNumbersChanged && !hasPermissionChanged && 
        !hasDayTypeChanged && !hasPasswordChanged) {
      _showSnackBar('لم يتم إجراء أي تغييرات');
      return;
    }

    // Calculate the new number
    final baseNumber = int.parse(_userData!['number']);
    final numbersDiff = int.parse(_numbersController.text) - int.parse(_userData!['numbers']);
    final newNumber = (baseNumber + (150 * numbersDiff)).toString();

    // Submit the edit
    context.read<EditcubitCubit>().edit(
      ip: _userData!['id'].toString(),
      names: _nameController.text,
      name: _userData!['name'],
      number: newNumber,
      numbers: _numbersController.text,
      pass: hasPasswordChanged ? _passController.text : _userData!['pass'] ?? _userData!['id'] ?? '',
      per: _permissionValue,
      day: _dayTypeValue,
    );
  }
}
