
import 'package:fina/tools/datadatafilter.dart';
import 'package:fina/tools/deligate.dart';


import 'package:fina/views/M.dart';
import 'package:fina/views/M2024.dart';
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

import 'package:fina/views/nonamedata.dart';
import 'package:fina/views/outing.dart';

import 'package:fina/views/outingtotal.dart';
import 'package:fina/views/per.dart';

import 'package:fina/views/refactory.dart';

import 'package:fina/views/total.dart';
import 'package:flutter/material.dart';

import '../tools/button.dart';
import 'add.dart';

class splash extends StatelessWidget {
  const splash({super.key});
  static String name = 'splash';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: "استعلام",
                      fun: () {
                        showSearch(
                          context: context,
                          delegate: datafilter(),
                        );
                      },
                    ),
                    custbutton(
                      hint: 'تعديل اخر عملية',
                      fun: () {
                        showSearch(
                          context: context,
                          delegate: datafilterss(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                        hint: "خارجي",
                        fun: () {
                          Navigator.pushNamed(context, outing.name);
                        }),
                    custbutton(
                      hint: "بدون اسم",
                      fun: () {
                        Navigator.pushNamed(context, hhhh.name);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: 'اضافة',
                      fun: () {
                        Navigator.pushNamed(context, add.name);
                      },
                    ),
                    custbutton(
                      hint: 'تعديل',
                      fun: () {
                        showSearch(
                          context: context,
                          delegate: datafilters(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: "اجمالي الخارجي",
                      fun: () {
                        Navigator.pushNamed(context, OutTotal.name);
                      },
                    ),
                    custbutton(
                      hint: 'الاجمالي',
                      fun: () {
                        Navigator.pushNamed(context, Total.name);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: 'تعديل الكل',
                      fun: () {
                        Navigator.pushNamed(context, EditAll.name);
                      },
                    ),
                    custbutton(
                      hint: 'اعادة الضبط',
                      fun: () {
                        Navigator.pushNamed(context, refactor.name);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: 'حظر',
                      fun: () {
                        showSearch(
                          context: context,
                          delegate: datafilterblock(),
                        );
                      },
                    ),
                    custbutton(
                      hint: 'الاذن',
                      fun: () {
                        showSearch(
                          context: context,
                          delegate: datafilterper(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: 'الصرف اليومي',
                      fun: () {
                        showSearch(
                          context: context,
                          delegate: dayfilter(),
                        );
                      },
                    ),
                    custbutton(
                      hint: 'حذف',
                      fun: () {
                        showSearch(
                          context: context,
                          delegate: delfilter(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: 'التوزيع',
                      fun: () {
                        showSearch(context: context, delegate: disdeli());
                      },
                    ),
                    custbutton(
                      hint: 'الاشتراكات',
                      fun: () {
                        Navigator.pushNamed(context, Month.name);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: 'دفع',
                      fun: () {
                        showSearch(context: context, delegate: dfdeli());
                      },
                    ),
                    custbutton(
                      hint: "اجمالي الاشتراكات",
                      fun: () {
                        Navigator.pushNamed(context, dfTotal.name);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    custbutton(
                      hint: "اجمالي اشتراكات التوزيع",
                      fun: () {
                        Navigator.pushNamed(context, dfTotal.name);
                      },
                    ),
                    custbutton(
                      hint: "اضافة للتوزيع",
                      fun: () {
                        Navigator.pushNamed(context, Addcard.name);
                      },
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  custbutton(
                    hint: 'طباعة ',
                    fun: () {
                      Navigator.pushNamed(context, ChMonth.name);
                    },
                  ),
                  custbutton(
                    hint: "فرق العيش",
                    fun: () {
                      showSearch(
                        context: context,
                        delegate: frkfilter(),
                      );
                    },
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  custbutton(
                      hint: 'حذف من التوزيع',
                      fun: () {
                        showSearch(context: context, delegate: DeleteFilter());
                      }),
                  custbutton(
                      hint: "تعديل الاشتراك",
                      fun: () {
                        showSearch(context: context, delegate: mondeli());
                      }),
                ]),
                custbutton(
                  hint: "اشتراكات 2024",
                  fun: () {
                    Navigator.pushNamed(context,Month2024.name);
                  },
                ),
              custbutton(
                    hint: 'طباعة ',
                    fun: () {
                      Navigator.pushNamed(context, ChMonth2024.name);
                    },
                  ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
