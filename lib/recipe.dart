class Recipe {
  List<String> images;
  List<String> tags;
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Recipe({
    required this.images,
    required this.tags,
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}
