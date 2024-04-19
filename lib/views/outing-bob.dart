import 'package:cubit_form/cubit_form.dart';
import 'package:fina/cubit/nodata_cubit.dart';

import 'package:fina/tools/button.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:fina/views/outingprinting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class outing extends StatefulWidget {
  const outing({super.key});
  static const String name = 'outing';

  @override
  State<outing> createState() => _outingState();
}

class _outingState extends State<outing> {
  bool vv = false;
  GlobalKey<FormState> GG = GlobalKey();
  TextEditingController pp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          title: const Text('خارجي'),
        ),
        body: BlocListener<NodataCubit, NodataState>(
          listener: (context, state) {
            if (state is Nodataloading) {
              vv = true;
              setState(() {});
            } else if (state is Nodatasuc) {
              vv = false;
              setState(() {});
              Navigator.pushNamed(context, outingprinting.name,
                  arguments: state.hh);
            } else if (state is Nodatafail) {
              vv = false;
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(' هناك خطأ في الاتصال بالشبكة حاول مرة اخري')));
            }
          },
          child: ModalProgressHUD(
            inAsyncCall: vv,
            child: Form(
              key: GG,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '5',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(5);
                              }),
                          custbutton(
                            x: 80,
                            y: 10,
                            hint: '10',
                            fun: () {
                              BlocProvider.of<NodataCubit>(context).nodatas(10);
                            },
                          ),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '15',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(15);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '20',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(20);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '25',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(25);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '30',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(30);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '35',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(35);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '40',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(40);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '45',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(45);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '50',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(50);
                              }),
                          custbutton(
                              x: 80,
                              y: 10,
                              hint: '100',
                              fun: () {
                                BlocProvider.of<NodataCubit>(context)
                                    .nodatas(100);
                              }),
                        ]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  custfiled(
                    hh: [FilteringTextInputFormatter.digitsOnly],
                    len: 3,
                    val: (value) {
                      if (value!.isEmpty || int.parse(value) % 5 != 0) {
                        return 'قيمة خاطئة';
                      }
                      return null;
                    },
                    jj: pp,
                    onfiledsubmited: (value) {
                      if (GG.currentState!.validate()) {
                        BlocProvider.of<NodataCubit>(context)
                            .nodatas(int.parse(value));
                        pp.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
