import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_recipes/results_page.dart';
import 'package:http/http.dart' as http;

import 'info_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.title}) : super(key: key);

  final String title;

  set searchTerm(String searchTerm) {}

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int currentPageIndex = 0;
  final _searchController = TextEditingController();
  late Future<Wrap> futureAllTags;
  late String searchTerm;

  @override
  void initState() {
    super.initState();
    futureAllTags = _getAllTags();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontFamily: "ConeriaScript", fontSize: 25.0),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return const InfoPage(
                      title: 'Info',
                    );
                  },
                ),
              );
            },
            child: const Icon(
              Icons.info,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  maxLength: 50,
                  enableSuggestions: true,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                  ),
                  onSubmitted: (value) {
                    searchTerm = value;
                    _searchRecipes(0);
                  },
                ),
                const SizedBox(height: 25),
                FutureBuilder<Wrap>(
                  future: futureAllTags,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Wrap> _getAllTags() async {
    final response = await http.get(
      Uri.parse('http://footeware.ca:8060/recipes/tags'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic Y3JhaWc6Y2hvY29sYXRl',
      },
    );
    final responseJson = jsonDecode(response.body);
    List<ActionChip> chips = [];
    ActionChip chip;
    for (String tag in responseJson) {
      chip = ActionChip(
        backgroundColor: Colors.amberAccent,
        label: Text(tag),
        onPressed: () {
          searchByTag(tag);
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

  _searchRecipes(int pageKey) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return SearchResultsPage(
            searchTerm: searchTerm,
            isTag: false,
          );
        },
      ),
    );
  }

  void searchByTag(String tag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return SearchResultsPage(
            searchTerm: tag,
            isTag: true,
          );
        },
      ),
    );
  }
}
