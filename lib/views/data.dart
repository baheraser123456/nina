import 'package:fina/cubit/cubit/vheck_cubit.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';

import 'package:fina/tools/button.dart';
import 'package:fina/tools/txtfiled.dart';
import 'package:fina/views/addion.dart';
import 'package:fina/views/history.dart';

import 'package:fina/views/printing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class hhh extends StatefulWidget {
  const hhh({super.key});
  static const name = 'hh';

  @override
  State<hhh> createState() => _hhhState();
}

class _hhhState extends State<hhh> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  bool vv = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(controller);
  }

  int? now;
  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)!.settings.arguments as String;

    GlobalKey<FormState> GG = GlobalKey();

    BlocProvider.of<DatacubitCubit>(context).getdata(name);
    return BlocConsumer<DatacubitCubit, DatacubitState>(
      builder: (context, state) => state is Datacubitsuc
          ? state.data['data'][0]['stutas'] == 'true' &&
                  state.data['data'][0]['per'] == 'باذن' &&
                  state.data['data'][0]['day'] == 'يومي'
              ? Form(
                  key: GG,
                  child: Scaffold(
                      appBar: AppBar(
                        title: const Text('البيانات'),
                      ),
                      body: ListView(children: [
                        _createDataTable(
                            context: context,
                            B: state.data['data'][0]['name'],
                            A: state.data['data'][0]['id'],
                            C: state.data['data'][0]['number'],
                            E: state.data['data'][0]['numbers'],
                            F: state.data['data'][0]['last'],
                            G: state.data['data'][0]['date'],
                            H: state.data['data'][0]['per'],
                            I: state.data['data'][0]['bk']),
                        Padding(
                          padding: const EdgeInsets.only(right: 85),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BlocBuilder<VheckCubit, VheckState>(
                                builder: (BuildContext context, state) =>
                                    Checkbox(
                                        value: vv,
                                        onChanged: (value) {
                                          BlocProvider.of<VheckCubit>(context)
                                              .onchanged();
                                          vv = value ?? false;
                                        }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        custfiled(
                          hint: 'عدد الارغفة',
                          hh: [FilteringTextInputFormatter.digitsOnly],
                          onfiledsubmited: (value) {
                            now = int.tryParse(value);
                            if (GG.currentState!.validate()) {
                              if (now! >
                                      int.parse(
                                          state.data['data'][0]['number']) ||
                                  now! % 5 != 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('قيمة خاطئة')));
                              } else if ((int.parse(
                                              state.data['data'][0]['std']) -
                                          int.parse(
                                              state.data['data'][0]['number']) +
                                          now!) /
                                      DateTime.now().day >
                                  int.parse(state.data['data'][0]['numbers']) *
                                      5) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('تخطيت الحد اليومي')));
                              } else {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content: const Text("تم الدفع؟"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<DatacubitCubit>(
                                                  context)
                                              .update(state, context,
                                                  now: now!, bk: now! / 20);
                                        },
                                        child: const Text('لا'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<DatacubitCubit>(
                                                  context)
                                              .update(state, context,
                                                  now: now!, bk: 0);
                                        },
                                        child: const Text('نعم'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          val: (data) {
                            if (data!.isEmpty || !vv) {
                              return 'حقل مطلوب';
                            } else if (int.tryParse(data) == 0) {
                              return 'قيمة خاطئة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        custbutton(
                            hint: (int.parse(state.data['data'][0]['numbers']) *
                                    5)
                                .toString(),
                            fun: () {
                              now =
                                  int.parse(state.data['data'][0]['numbers']) *
                                      5;
                              if (!vv ||
                                  now! >
                                      int.parse(
                                          state.data['data'][0]['number'])) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('قيمة خاطئة')));
                              } else if ((int.parse(
                                              state.data['data'][0]['std']) -
                                          int.parse(
                                              state.data['data'][0]['number']) +
                                          now!) /
                                      DateTime.now().day >
                                  int.parse(state.data['data'][0]['numbers']) *
                                      5) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('تخطيت الحد اليومي')));
                              } else {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content: const Text("تم الدفع؟"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<DatacubitCubit>(
                                                  context)
                                              .update(state, context,
                                                  now: now!, bk: now! / 20);
                                        },
                                        child: const Text('لا'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<DatacubitCubit>(
                                                  context)
                                              .update(state, context,
                                                  now: now!, bk: 0);
                                        },
                                        child: const Text('نعم'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                        custbutton(
                          hint: 'السجل',
                          fun: () {
                            Navigator.popAndPushNamed(context, history.name,
                                arguments: state.data['data'][0]['id']);
                          },
                        ),
                        custbutton(
                          hint: "اضافة عيش",
                          fun: () {
                            List hh = [
                              state.data['data'][0]['id'],
                              state.data['data'][0]['name']
                            ];
                            Navigator.popAndPushNamed(context, Addion.name,
                                arguments: hh);
                          },
                        )
                      ])),
                )
              : state.data['data'][0]['stutas'] == 'true' &&
                      state.data['data'][0]['per'] == 'بدون اذن' &&
                      state.data['data'][0]['day'] == 'يومي'
                  ? Form(
                      key: GG,
                      child: Scaffold(
                          appBar: AppBar(
                            title: const Text('البيانات'),
                          ),
                          body: ListView(children: [
                            _createDataTable(
                                context: context,
                                B: state.data['data'][0]['name'],
                                A: state.data['data'][0]['id'],
                                C: state.data['data'][0]['number'],
                                E: state.data['data'][0]['numbers'],
                                F: state.data['data'][0]['last'],
                                G: state.data['data'][0]['date'],
                                H: state.data['data'][0]['per'],
                                I: state.data['data'][0]['bk']),
                            const SizedBox(
                              height: 70,
                            ),
                            custfiled(
                              hint: 'عدد الارغفة',
                              hh: [FilteringTextInputFormatter.digitsOnly],
                              onfiledsubmited: (value) {
                                now = int.tryParse(value);
                                if (GG.currentState!.validate()) {
                                  if (now! >
                                          int.parse(state.data['data'][0]
                                              ['number']) ||
                                      now! % 5 != 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('قيمة خاطئة')));
                                  } else if ((int.parse(state.data['data'][0]
                                                  ['std']) -
                                              int.parse(state.data['data'][0]
                                                  ['number']) +
                                              now!) /
                                          DateTime.now().day >
                                      int.parse(state.data['data'][0]
                                              ['numbers']) *
                                          5) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('تخطيت الحد اليومي')));
                                  } else {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content: const Text("تم الدفع؟"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              BlocProvider.of<DatacubitCubit>(
                                                      context)
                                                  .update(state, context,
                                                      now: now!, bk: now! / 20);
                                            },
                                            child: const Text('لا'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              BlocProvider.of<DatacubitCubit>(
                                                      context)
                                                  .update(state, context,
                                                      now: now!, bk: 0);
                                            },
                                            child: const Text('نعم'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              val: (data) {
                                if (data!.isEmpty) {
                                  return 'حقل مطلوب';
                                } else if (int.tryParse(data) == 0) {
                                  return 'قيمة خاطئة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            custbutton(
                                hint: (int.parse(
                                            state.data['data'][0]['numbers']) *
                                        5)
                                    .toString(),
                                fun: () {
                                  now = int.parse(
                                          state.data['data'][0]['numbers']) *
                                      5;
                                  if (now! >
                                      int.parse(
                                          state.data['data'][0]['number'])) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('قيمة خاطئة')));
                                  } else if ((int.parse(state.data['data'][0]
                                                  ['std']) -
                                              int.parse(state.data['data'][0]
                                                  ['number']) +
                                              now!) /
                                          DateTime.now().day >
                                      int.parse(state.data['data'][0]
                                              ['numbers']) *
                                          5) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('تخطيت الحد اليومي')));
                                  } else {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content: const Text("تم الدفع؟"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              BlocProvider.of<DatacubitCubit>(
                                                      context)
                                                  .update(state, context,
                                                      now: now!, bk: now! / 20);
                                            },
                                            child: const Text('لا'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              BlocProvider.of<DatacubitCubit>(
                                                      context)
                                                  .update(state, context,
                                                      now: now!, bk: 0);
                                            },
                                            child: const Text('نعم'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                            custbutton(
                              hint: 'السجل',
                              fun: () {
                                Navigator.popAndPushNamed(context, history.name,
                                    arguments: state.data['data'][0]['id']);
                              },
                            ),
                            custbutton(
                              hint: "اضافة عيش",
                              fun: () {
                                List hh = [
                                  state.data['data'][0]['id'],
                                  state.data['data'][0]['name']
                                ];
                                Navigator.popAndPushNamed(context, Addion.name,
                                    arguments: hh);
                              },
                            )
                          ])),
                    )
                  : state.data['data'][0]['stutas'] == 'true' &&
                          state.data['data'][0]['per'] == 'باذن'
                      ? Form(
                          key: GG,
                          child: Scaffold(
                              appBar: AppBar(
                                title: const Text('البيانات'),
                              ),
                              body: ListView(children: [
                                _createDataTable(
                                    context: context,
                                    B: state.data['data'][0]['name'],
                                    A: state.data['data'][0]['id'],
                                    C: state.data['data'][0]['number'],
                                    E: state.data['data'][0]['numbers'],
                                    F: state.data['data'][0]['last'],
                                    G: state.data['data'][0]['date'],
                                    H: state.data['data'][0]['per'],
                                    I: state.data['data'][0]['bk']),
                                Padding(
                                  padding: const EdgeInsets.only(right: 85),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BlocBuilder<VheckCubit, VheckState>(
                                        builder: (BuildContext context,
                                                state) =>
                                            Checkbox(
                                                value: vv,
                                                onChanged: (value) {
                                                  BlocProvider.of<VheckCubit>(
                                                          context)
                                                      .onchanged();
                                                  vv = value ?? false;
                                                }),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                                custfiled(
                                  hint: 'عدد الارغفة',
                                  hh: [FilteringTextInputFormatter.digitsOnly],
                                  onfiledsubmited: (value) {
                                    now = int.tryParse(value);
                                    if (GG.currentState!.validate()) {
                                      if (now! >
                                              int.parse(state.data['data'][0]
                                                  ['number']) ||
                                          now! % 5 != 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('قيمة خاطئة')));
                                      } else {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            content: const Text("تم الدفع؟"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              DatacubitCubit>(
                                                          context)
                                                      .update(state, context,
                                                          now: now!,
                                                          bk: now! / 20);
                                                },
                                                child: const Text('لا'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              DatacubitCubit>(
                                                          context)
                                                      .update(state, context,
                                                          now: now!, bk: 0);
                                                },
                                                child: const Text('نعم'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  val: (data) {
                                    if (data!.isEmpty || !vv) {
                                      return 'حقل مطلوب';
                                    } else if (int.tryParse(data) == 0) {
                                      return 'قيمة خاطئة';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    custbutton(
                                        hint: '5',
                                        fun: () {
                                          now = 5;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                    custbutton(
                                      hint: '10',
                                      fun: () {
                                        now = 10;
                                        if (!vv ||
                                            now! >
                                                int.parse(state.data['data'][0]
                                                    ['number'])) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text('قيمة خاطئة')));
                                        } else {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              content: const Text("تم الدفع؟"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                DatacubitCubit>(
                                                            context)
                                                        .update(state, context,
                                                            now: now!,
                                                            bk: now! / 20);
                                                  },
                                                  child: const Text('لا'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                DatacubitCubit>(
                                                            context)
                                                        .update(state, context,
                                                            now: now!, bk: 0);
                                                  },
                                                  child: const Text('نعم'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    custbutton(
                                        hint: '15',
                                        fun: () {
                                          now = 15;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                    custbutton(
                                        hint: '20',
                                        fun: () {
                                          now = 20;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    custbutton(
                                        hint: '25',
                                        fun: () {
                                          now = 25;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                    custbutton(
                                        hint: '30',
                                        fun: () {
                                          now = 30;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    custbutton(
                                        hint: '35',
                                        fun: () {
                                          now = 35;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                    custbutton(
                                        hint: '40',
                                        fun: () {
                                          now = 40;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    custbutton(
                                        hint: '45',
                                        fun: () {
                                          now = 45;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                    custbutton(
                                        hint: '50',
                                        fun: () {
                                          now = 50;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    custbutton(
                                        hint: '100',
                                        fun: () {
                                          now = 100;
                                          if (!vv ||
                                              now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        })
                                  ],
                                ),
                                custbutton(
                                  hint: 'السجل',
                                  fun: () {
                                    Navigator.popAndPushNamed(
                                        context, history.name,
                                        arguments: state.data['data'][0]['id']);
                                  },
                                ),
                                custbutton(
                                  hint: "اضافة عيش",
                                  fun: () {
                                    List hh = [
                                      state.data['data'][0]['id'],
                                      state.data['data'][0]['name']
                                    ];
                                    Navigator.popAndPushNamed(
                                        context, Addion.name,
                                        arguments: hh);
                                  },
                                )
                              ])),
                        )
                      : state.data['data'][0]['stutas'] == 'true' &&
                              state.data['data'][0]['per'] == 'بدون اذن'
                          ? Form(
                              key: GG,
                              child: Scaffold(
                                  appBar: AppBar(
                                    title: const Text('البيانات'),
                                  ),
                                  body: ListView(children: [
                                    _createDataTable(
                                        context: context,
                                        B: state.data['data'][0]['name'],
                                        A: state.data['data'][0]['id'],
                                        C: state.data['data'][0]['number'],
                                        E: state.data['data'][0]['numbers'],
                                        F: state.data['data'][0]['last'],
                                        G: state.data['data'][0]['date'],
                                        H: state.data['data'][0]['per'],
                                        I: state.data['data'][0]['bk']),
                                    const SizedBox(
                                      height: 70,
                                    ),
                                    custfiled(
                                      hh: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onfiledsubmited: (value) {
                                        now = int.parse(value);
                                        if (GG.currentState!.validate()) {
                                          if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number']) ||
                                              now! % 5 != 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('قيمة خاطئة')));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content:
                                                    const Text("تم الدفع؟"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!,
                                                              bk: now! / 20);
                                                    },
                                                    child: const Text('لا'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  DatacubitCubit>(
                                                              context)
                                                          .update(
                                                              state, context,
                                                              now: now!, bk: 0);
                                                    },
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      val: (data) {
                                        if (data!.isEmpty) {
                                          return 'حقل مطلوب';
                                        } else if (int.tryParse(data) == 0) {
                                          return 'قيمة خاطئة';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        custbutton(
                                            hint: '5',
                                            fun: () {
                                              now = 5;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                        custbutton(
                                          hint: '10',
                                          fun: () {
                                            now = 10;
                                            if (now! >
                                                int.parse(state.data['data'][0]
                                                    ['number'])) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content:
                                                          Text('قيمة خاطئة')));
                                            } else {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  content:
                                                      const Text("تم الدفع؟"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                                    DatacubitCubit>(
                                                                context)
                                                            .update(
                                                                state, context,
                                                                now: now!,
                                                                bk: now! / 20);
                                                      },
                                                      child: const Text('لا'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                                    DatacubitCubit>(
                                                                context)
                                                            .update(
                                                                state, context,
                                                                now: now!,
                                                                bk: 0);
                                                      },
                                                      child: const Text('نعم'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        custbutton(
                                            hint: '15',
                                            fun: () {
                                              now = 15;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                        custbutton(
                                            hint: '20',
                                            fun: () {
                                              now = 20;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            })
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        custbutton(
                                            hint: '25',
                                            fun: () {
                                              now = 25;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                        custbutton(
                                            hint: '30',
                                            fun: () {
                                              now = 30;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            })
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        custbutton(
                                            hint: '35',
                                            fun: () {
                                              now = 35;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                        custbutton(
                                            hint: '40',
                                            fun: () {
                                              now = 40;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            })
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        custbutton(
                                            hint: '45',
                                            fun: () {
                                              now = 45;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                        custbutton(
                                            hint: '50',
                                            fun: () {
                                              now = 50;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            })
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        custbutton(
                                            hint: '100',
                                            fun: () {
                                              now = 100;
                                              if (now! >
                                                  int.parse(state.data['data']
                                                      [0]['number'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'قيمة خاطئة')));
                                              } else {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    content:
                                                        const Text("تم الدفع؟"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: now! /
                                                                      20);
                                                        },
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                      DatacubitCubit>(
                                                                  context)
                                                              .update(state,
                                                                  context,
                                                                  now: now!,
                                                                  bk: 0);
                                                        },
                                                        child:
                                                            const Text('نعم'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }),
                                        custbutton(
                                          hint: 'السجل',
                                          fun: () {
                                            Navigator.popAndPushNamed(
                                                context, history.name,
                                                arguments: state.data['data'][0]
                                                    ['id']);
                                          },
                                        ),
                                        custbutton(
                                          hint: "اضافة عيش",
                                          fun: () {
                                            List hh = [
                                              state.data['data'][0]['id'],
                                              state.data['data'][0]['name']
                                            ];
                                            Navigator.popAndPushNamed(
                                                context, Addion.name,
                                                arguments: hh);
                                          },
                                        )
                                      ],
                                    ),
                                  ])),
                            )
                          : Scaffold(
                              appBar: AppBar(),
                              body: Center(
                                child: Text(
                                    ' هذا المستخدم محظور بسبب ${state.data['data'][0]['res']}'),
                              ),
                            )
          : state is Datacubitloading
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : state is Datacubitfail
                  ? Scaffold(
                      appBar: AppBar(),
                      body: const Center(
                        child: Text('هناك خطا في الشبكة'),
                      ),
                    )
                  : Scaffold(
                      appBar: AppBar(),
                      body: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
      listener: (BuildContext context, DatacubitState state) {
        if (state is Datacubitsuc) {
          BlocProvider.of<DatacubitCubit>(context).hh = [
            state.data['data'][0]['name'],
            state.data['data'][0]['id'].toString(),
          ];
        }
        if (state is Datacubitsucs) {
          BlocProvider.of<DatacubitCubit>(context).hh.insert(1, now.toString());
          BlocProvider.of<DatacubitCubit>(context).hh.insert(2, state.zz);
          BlocProvider.of<DatacubitCubit>(context)
              .hh
              .add(state.data['data'][0]['id']);

          Navigator.popAndPushNamed(context, Printing.name,
              arguments: BlocProvider.of<DatacubitCubit>(context).hh);
        }
      },
    );
  }

  DataTable _createDataTable(
      {required BuildContext context,
      required A,
      required B,
      required C,
      required E,
      required F,
      required G,
      required H,
      required I}) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(
            context: context, A: A, B: B, C: C, E: E, F: F, G: G, H: H, I: I));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('الكود')),
      const DataColumn(label: Text(' صاحب البطاقة')),
      const DataColumn(label: Text('عدد الأرغفة')),
      const DataColumn(label: Text('عدد الأفراد')),
      const DataColumn(label: Text('اخر سحب')),
      const DataColumn(label: Text('تاريخ ')),
      const DataColumn(label: Text('الاذن ')),
      const DataColumn(label: Text('الاشتراك')),
    ];
  }

  List<DataRow> _createRows(
      {required BuildContext context,
      required A,
      required B,
      required C,
      required E,
      required F,
      required G,
      required H,
      required I}) {
    return [
      DataRow(cells: [
        DataCell(Text(A.toString())),
        DataCell(Text(B)),
        DataCell(Text(C.toString())),
        DataCell(Text(E.toString())),
        DataCell(Text(F.toString())),
        DataCell(Text(G.toString())),
        DataCell(Text(H.toString())),
        DataCell(Text(I.toString())),
      ]),
    ];
  }
}
