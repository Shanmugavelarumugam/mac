

import 'package:web_app/data/model/image_result_model.dart';
import 'package:web_app/data/model/search_result_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchTextLoaded extends SearchState {
  final List<SearchResult> results;
  SearchTextLoaded(this.results);
}

class SearchImagesLoaded extends SearchState {
  final List<ImageResult> results;
  SearchImagesLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
// search_state.dart
class SearchSuggestionsLoaded extends SearchState {
  final List<String> suggestions;
  SearchSuggestionsLoaded(this.suggestions);
}

