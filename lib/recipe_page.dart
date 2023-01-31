import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipes/recipe.dart';
import 'package:flutter_recipes/results_page.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:share_plus/share_plus.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.name,
          style: const TextStyle(fontSize: 18.0),
        ),
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
            for (String imageId in recipe.imageIds) getImage(imageId)
          ],
        ),
      ),
    );
  }

  getImage(String imageId) {
    return GestureZoomBox(
      child: CachedNetworkImage(
        imageUrl: 'http://footeware.ca:9000/recipes/images/$imageId',
        placeholder: (context, url) =>
            const CircularProgressIndicator(color: Colors.deepPurple),
        httpHeaders: const {
          "Authorization": 'Basic Y3JhaWc6Y2hvY29sYXRl',
        },
      ),
    );
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
