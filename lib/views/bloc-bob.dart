import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/views/blockpage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class datafilterblock extends SearchDelegate {
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
    List hh = BlocProvider.of<GetCubit>(context).gata;

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
              Navigator.popAndPushNamed(
                context,
                blockpage.name,
                arguments: sug[index],
              );
            },
          );
        });
  }
}
