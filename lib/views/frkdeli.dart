import 'package:fina/class.dart';
import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/views/data.dart';
import 'package:fina/views/frk.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class frkfilter extends SearchDelegate {
  @override
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: const Icon(Icons.search))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('لا يوجد');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Data?> gg = BlocProvider.of<GetCubit>(context).frk;
    List hh = [];
    for (var element in gg) {
      hh.add(element!.name);
    }
    var sug = query.isEmpty
        ? hh
        : query.split(" ").length == 2
            ? hh
                .where((element) =>
                    element.startsWith(query.split(' ')[0]) &&
                        element.contains(query.split(" ")[1]) ||
                    element.contains(query))
                .toList()
            : query.split(" ").length == 3
                ? hh
                    .where((element) =>
                        element.startsWith(query.split(' ')[0]) &&
                            element.contains(query.split(" ")[2]) ||
                        element.contains(query))
                    .toList()
                : query.split(" ").length == 4
                    ? hh
                        .where((element) =>
                            element.startsWith(query.split(' ')[0]) &&
                                element.contains(query.split(" ")[3]) ||
                            element.contains(query))
                        .toList()
                    : hh
                        .where((element) =>
                            element.startsWith(query.split(" ")[0]) ||
                            element.contains(query.split(' ')[0]))
                        .toList();
    return ListView.builder(
        itemCount: sug.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(title: Text(sug[index])),
            onTap: () {
              Navigator.pushNamed(context, Frk.name, arguments: sug[index]!);
            },
          );
        });
  }
}
