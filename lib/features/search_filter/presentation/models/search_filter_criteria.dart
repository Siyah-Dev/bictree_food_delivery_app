
class SearchFilterCriteria {
  SearchFilterCriteria({
    required this.category,
    required List<String> selectedTags,
    required this.minimumRating,
    required this.maximumPrice,
  }) : selectedTags = List.unmodifiable(selectedTags);

  final String category;
  final List<String> selectedTags;
  final int minimumRating;
  final double maximumPrice;
}
