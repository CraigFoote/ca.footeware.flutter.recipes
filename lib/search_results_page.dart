import 'dart:convert';
import 'dart:io';
import 'package:flutter_recipes/recipe_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_recipes/recipe.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage(
      {Key? key, required this.searchTerm, required this.isTag})
      : super(key: key);

  final String searchTerm;
  final bool isTag;

  @override
  State<StatefulWidget> createState() => SearchResultsPageState();
}

class SearchResultsPageState extends State<SearchResultsPage> {
  static const _pageSize = 20;
  int _total = 0;
  late String _title;

  final PagingController<int, Recipe> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _title = "";
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageNumber) async {
    try {
      String url;
      if (widget.isTag) {
        url =
            'http://footeware.ca:8060/recipes/search/tags?tag=${widget.searchTerm}&pageNumber=$pageNumber&pageSize=$_pageSize';
      } else {
        url =
            'http://footeware.ca:8060/recipes/search?term=${widget.searchTerm}&pageNumber=$pageNumber&pageSize=$_pageSize';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic Y3JhaWc6Y2hvY29sYXRl',
        },
      );
      final responseList = jsonDecode(response.body);
      _total = responseList['total'];
      setTitle();
      List<dynamic> rawList = responseList['recipes'];

      List<Recipe> recipeList = [];
      for (Map<String, dynamic> map in rawList) {
        String name = map['name']!;
        String body = map['body']!;
        List<dynamic> images = map['images'];
        List<dynamic> tags = map['tags'];
        recipeList.add(Recipe(
            images: toStringList(images),
            tags: toStringList(tags),
            body: body,
            name: name));
      }

      final isLastPage = rawList.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(recipeList);
      } else {
        final nextPageKey = pageNumber + rawList.length;
        _pagingController.appendPage(recipeList, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  //TODO why the hell is this necessary?
  List<String> toStringList(List list) {
    List<String> result = [];
    for (String string in list) {
      result.add(string);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: PagedListView<int, Recipe>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Recipe>(
            itemBuilder: (context, item, index) => Card(
              margin: const EdgeInsets.all(10.0),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return RecipePage(
                            recipe: item,
                          );
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_right,
                        color: Colors.deepPurple,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  setTitle() {
    setState(() {
      _title = widget.isTag
          ? "$_total with tag '${widget.searchTerm}'"
          : "$_total with '${widget.searchTerm}'";
    });
  }
}
