abstract class SearchEvent {}

class SearchTextEvent extends SearchEvent {
  final String query;
  SearchTextEvent(this.query);
}

class SearchImagesEvent extends SearchEvent {
  final String query;
  SearchImagesEvent(this.query);
}

// search_event.dart
class SearchSuggestionsEvent extends SearchEvent {
  final String query;
  SearchSuggestionsEvent(this.query);
}
