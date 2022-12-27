import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_recipes/recipe.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<StatefulWidget> createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  widget.recipe.body,
                  style: const TextStyle(fontSize: 22.0),
                ),
              ),
              for (String base64 in widget.recipe.images)
                Image.memory(base64Decode(base64.substring(23))),
            ],
          ),
        ));
  }
}
