import 'package:fina/getcubit/get_cubit.dart';
import 'package:fina/views/cp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class cardsdelis extends SearchDelegate {
  @override
  @override
  cardsdelis({required this.gg});
  int gg;
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
    List hh = BlocProvider.of<GetCubit>(context).cata;

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
              List hh = [sug[index], gg];
              Navigator.pushNamed(
                context,
                cardspages.name,
                arguments: hh,
              );
            },
          );
        });
  }
}
