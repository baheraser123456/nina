import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/views/edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class datafilters extends SearchDelegate {
  @override
  datafilters();
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
        : hh
            .where((element) =>
                element.startsWith(query) || element.contains(query))
            .toList();
    return ListView.builder(
        itemCount: sug.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(title: Text(sug[index])),
            onTap: () {
              Navigator.popAndPushNamed(
                context,
                Edit.name,
                arguments: sug[index],
              );
            },
          );
        });
  }
}
