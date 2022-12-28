import 'dart:convert';
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: SelectableText(
                  recipe.body,
                  style: const TextStyle(fontSize: 22.0),
                ),
              ),
              for (String base64 in recipe.images) getImage(base64)
            ],
          ),
        ),
      ),
    );
  }

  getImage(String base64) {
    return InteractiveViewer(
      maxScale: 5.0,
      minScale: 0.5,
      child: Image.memory(
        base64Decode(base64.substring(23)),
      ),

    );
  }
}
