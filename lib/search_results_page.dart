import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_recipes/recipe.dart';

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
  late int _pageNumber;
  final int _pageSize = 10;
  late List<Recipe> _recipes;
  late bool _loading;
  late bool _error;
  late bool _isLastPage;
  final int _nextPageTrigger = 3;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _isLastPage = false;
    _error = false;
    _pageNumber = 0;
    _recipes = [];
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: buildRecipesPage(),
    );
  }

  buildRecipesPage() {
    if (_recipes.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(child: Text(_error.toString()));
      }
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionPanelList(
        dividerColor: Colors.deepPurple,
        elevation: 3.0,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _recipes[index].isExpanded = !isExpanded;
          });
        },
        children: getContent(),
      ),
    );
  }

  getContent() {
    List<ExpansionPanel> list = [];
    for (Recipe recipe in _recipes) {
      int index = _recipes.indexOf(recipe);
      if (index == _recipes.length - _nextPageTrigger) {
        fetchData();
      }
      ExpansionPanel panel = ExpansionPanel(
        canTapOnHeader: true,
        isExpanded: true,
        headerBuilder: (context, isExpanded) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipe.headerValue, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recipe.expandedValue, style: const TextStyle(fontSize: 20.0),),
        ),
      );
      list.add(panel);
    }
    return list;
  }

  Future<void> fetchData() async {
    try {
      String url;
      if (widget.isTag) {
        url =
            'http://footeware.ca:8060/recipes/search/tags?tag=${widget.searchTerm}&pageNumber=$_pageNumber&pageSize=$_pageSize';
      } else {
        url =
            'http://footeware.ca:8060/recipes/search?term=${widget.searchTerm}&pageNumber=$_pageNumber&pageSize=$_pageSize';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic Y3JhaWc6Y2hvY29sYXRl',
        },
      );
      final responseList = jsonDecode(response.body);
      List<Recipe> recipeList = [];
      List<dynamic> rawList = responseList['recipes'];
      for (Map<String, dynamic> map in rawList) {
        String name = map['name']!;
        String body = map['body']!;
        List<dynamic> images = map['images'];
        List<dynamic> tags = map['tags'];
        recipeList.add(Recipe(
            images: toStringList(images),
            tags: toStringList(tags),
            expandedValue: body,
            headerValue: name));
      }
      setState(() {
        _isLastPage = _recipes.length < _pageSize;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _recipes.addAll(recipeList);
      });
    } catch (e) {
      print("error --> $e");
      setState(() {
        _loading = false;
        _error = true;
      });
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
}

//   children: Builder(BuildContext context, int index, builder:
//     itemCount: _recipes.length + (_isLastPage ? 0 : 1),
//     itemBuilder: (context, index) {
//       if (index == _recipes.length - _nextPageTrigger) {
//         fetchData();
//       }
//       if (index == _recipes.length) {
//         if (_error) {
//           return Center(child: errorDialog(size: 15));
//         } else {
//           return const Center(
//             child: Padding(
//             padding: EdgeInsets.all(8),
//             child: CircularProgressIndicator(),
//           ),
//         );
//       }
//       final Recipe recipe = _recipes[index];
//       return SingleChildScrollView(
//         child: ExpansionPanelList(
//           dividerColor: Colors.deepPurple,
//           elevation: 3.0,
//           expansionCallback: (int index, bool isExpanded) {
//             setState(() {
//               recipe.isExpanded = !isExpanded;
//             });
//           },
//           children: getExpansionPanels(),
//         ),
//       );
//     },
//   );
// }

// Widget errorDialog({required double size}) {
//   return SizedBox(
//     height: 180,
//     width: 200,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'An error occurred when fetching the posts.',
//           style: TextStyle(
//               fontSize: size, fontWeight: FontWeight.w500, color: Colors.black),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         // FlatButton(
//         //     onPressed:  ()  {
//         //       setState(() {
//         //         _loading = true;
//         //         _error = false;
//         //         fetchData();
//         //       });
//         //     },
//         //     child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
//       ],
//     ),
//   );
// }
