import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fish.dart';
import 'fish_tile.dart';

class FishSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
          tooltip: 'Clear',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => BackButton();

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final fishes = Provider.of<List<Fish>>(context).where((f) {
      return f.name.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();

    return ListView.separated(
      itemCount: fishes.length,
      separatorBuilder: (_, __) => Divider(
        thickness: 1,
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (_, i) => FishTile(fish: fishes[i]),
    );
  }
}
