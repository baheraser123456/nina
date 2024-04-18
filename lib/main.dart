import 'package:fina/cubit/cubit/vheck_cubit.dart';
import 'package:fina/cubit/delcubit_cubit.dart';
import 'package:fina/cubit/nodata_cubit.dart';
import 'package:fina/cubit2/editcubit_cubit.dart';
import 'package:fina/cubit3/total_cubit.dart';
import 'package:fina/cubit9/login_cubit.dart';
import 'package:fina/datacubit/datacubit_cubit.dart';
import 'package:fina/observer.dart';
import 'package:fina/views/M.dart';
import 'package:fina/views/blockpage.dart';
import 'package:fina/views/cards_page.dart';
import 'package:fina/views/cardsprinting.dart';
import 'package:fina/views/day_page.dart';
import 'package:fina/views/delpage.dart';
import 'package:fina/views/df.dart';
import 'package:fina/views/dftotal.dart';
import 'package:fina/views/edit.dart';
import 'package:fina/views/editall.dart';
import 'package:fina/views/editdast.dart';
import 'package:fina/views/editdeli.dart';
import 'package:fina/views/editedit.dart';
import 'package:fina/views/editouting.dart';
import 'package:fina/views/history.dart';
import 'package:fina/views/nonamedata.dart';
import 'package:fina/views/nonamedprinting.dart';
import 'package:fina/views/outing.dart';
import 'package:fina/views/outingprinting.dart';
import 'package:fina/views/outingtotal.dart';
import 'package:fina/views/per_page.dart';
import 'package:fina/views/pos.dart';
import 'package:fina/views/posprinting.dart';
import 'package:fina/views/printing.dart';
import 'package:fina/views/refactory.dart';
import 'package:fina/views/total.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'addcubit/cubit/add_cubit.dart';
import 'getcubit/get_cubit.dart';
import 'views/Home.dart';
import 'views/add.dart';
import 'views/data.dart';
import 'views/search.dart';
import 'views/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddCubit>(
          create: (context) => AddCubit(),
        ),
        BlocProvider<GetCubit>(
          create: (context) => GetCubit(),
        ),
        BlocProvider<TotalCubit>(
          create: (context) => TotalCubit(),
        ),
        BlocProvider<DatacubitCubit>(
          create: (context) => DatacubitCubit(),
        ),
        BlocProvider<EditcubitCubit>(
          create: (context) => EditcubitCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<NodataCubit>(
          create: (context) => NodataCubit(),
        ),
        BlocProvider<VheckCubit>(
          create: (context) => VheckCubit(),
        ),
        BlocProvider<DelcubitCubit>(create: (context) => DelcubitCubit())
      ],
      child: MaterialApp(
        home: const Home(),
        routes: {
          splash.name: (context) => const splash(),
          searchedit.name: (context) => const searchedit(),
          add.name: (context) => const add(),
          hhh.name: (context) => const hhh(),
          Printing.name: (context) => const Printing(),
          hhhh.name: (context) => const hhhh(),
          NoNamePrinting.name: (context) => const NoNamePrinting(),
          Edit.name: (context) => const Edit(),
          editdeli.name: (context) => const editdeli(),
          Total.name: (context) => const Total(),
          refactor.name: (context) => const refactor(),
          editdelis.name: (context) => const editdelis(),
          EditLast.name: (context) => const EditLast(),
          EditAll.name: (context) => const EditAll(),
          outing.name: (context) => const outing(),
          OutTotal.name: (context) => const OutTotal(),
          outingprinting.name: (context) => const outingprinting(),
          blockpage.name: (context) => const blockpage(),
          lastouting.name: (context) => const lastouting(),
          perpage.name: (context) => const perpage(),
          daypage.name: (context) => const daypage(),
          Delete.name: (context) => const Delete(),
          cardspage.name: (context) => const cardspage(),
          cardsprinting.name: (context) => const cardsprinting(),
          posorinting.name: (context) => const posorinting(),
          pos.name: (context) => const pos(),
          Month.name: (context) => const Month(),
          df.name: (context) => const df(),
          dfTotal.name: (context) => const dfTotal(),
          history.name: (context) => const history()
        },
      ),
    );
  }
}
