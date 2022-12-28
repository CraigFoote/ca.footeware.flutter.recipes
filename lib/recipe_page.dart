import 'dart:convert';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipes/recipe.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText(
                recipe.body,
                style: const TextStyle(fontSize: 22.0),
              ),
              for (String base64 in recipe.images) getImage(base64, context)
            ],
          ),
        ),
      ),
    );
  }

  getImage(String base64, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: PinchZoom(
          maxScale: 10.0,
          child: Image(
            image: MemoryImage(
              base64Decode(base64.substring(23)),
            ),
          ),
        ),
      ),
    );
  }
}
