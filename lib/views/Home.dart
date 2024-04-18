import 'package:cubit_form/cubit_form.dart';

import 'package:fina/cubit9/login_cubit.dart';
import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/views/splash.dart';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../tools/button.dart';
import '../tools/txtfiled.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? email;
  TextEditingController name = TextEditingController();
  TextEditingController pas = TextEditingController();
  String? pass;
  bool? load;
  GlobalKey<FormState> gg = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is Loginloading) {
            load = true;
            setState(() {});
          } else if (state is Loginfail) {
            load = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('كلمة المرور او اسم المستخدم خطأ')));
          } else if (state is Loginsuc) {
            load = false;
            setState(() {});
            Navigator.pushNamed(context, splash.name);
            BlocProvider.of<GetCubit>(context).gets();
          }
        },
        child: ModalProgressHUD(
          inAsyncCall: load ?? false,
          child: Form(
            key: gg,
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      custfiled(
                          onfiledsubmited: (data) {
                            if (gg.currentState!.validate()) {
                              BlocProvider.of<LoginCubit>(context)
                                  .logins(email, pass);
                            }
                          },
                          jj: name,
                          hint: 'اسم المستخدم',
                          onsaved: (data) {
                            email = data;
                          },
                          val: (data) {
                            if (data!.isEmpty) {
                              return 'حقل مطلوب';
                            }
                            return null;
                          }),
                      custfiled(
                          onfiledsubmited: (data) {
                            if (gg.currentState!.validate()) {
                              BlocProvider.of<LoginCubit>(context)
                                  .logins(email, pass);
                            }
                          },
                          jj: pas,
                          zz: true,
                          hint: 'كلمة السر',
                          onsaved: (data) {
                            pass = data;
                          },
                          val: (data) {
                            if (data!.isEmpty) {
                              return 'حقل مطلوب';
                            }
                            return null;
                          }),
                      custbutton(
                          hint: 'تسجيل الدخول',
                          fun: () async {
                            if (gg.currentState!.validate()) {
                              BlocProvider.of<LoginCubit>(context)
                                  .logins(email, pass);
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
