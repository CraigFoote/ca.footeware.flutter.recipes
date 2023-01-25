import 'dart:convert';
import 'package:flutter_recipes/results_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:flutter_recipes/recipe.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name, style: const TextStyle(fontSize: 18.0),),
        actions: [
          ElevatedButton(
            onPressed: () {
              _share(context);
            },
            child: const Icon(
              Icons.share,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTags(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: SelectableText(
                recipe.body,
                style: const TextStyle(fontSize: 22.0),
              ),
            ),
            const Text(
              "Double tap to zoom",
              style: TextStyle(
                color: Colors.deepPurple,
                fontStyle: FontStyle.italic,
              ),
            ),
            for (String base64 in recipe.images) getImage(base64)
          ],
        ),
      ),
    );
  }

  getImage(String base64) {
    return GestureZoomBox(
        child: Image.memory(
      base64Decode(base64.substring(23)),
    ));
  }

  Future<void> _share(BuildContext context) async {
    Share.share("Annie Foote's ${recipe.name} recipe\n\n${recipe.body}");
  }

  Widget getTags(BuildContext context) {
    List<ActionChip> chips = [];
    ActionChip chip;
    for (String tag in recipe.tags) {
      chip = ActionChip(
        backgroundColor: Colors.amberAccent,
        label: Text(tag),
        onPressed: () {
          searchByTag(tag, context);
        },
        elevation: 5,
      );
      chips.add(chip);
    }
    return Wrap(
      spacing: 10,
      children: chips,
    );
  }

  void searchByTag(String tag, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ResultsPage(
            searchTerm: tag,
            isTag: true,
          );
        },
      ),
    );
  }
}
