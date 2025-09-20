import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_app/data/repository/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    // Handle search text
    on<SearchTextEvent>((event, emit) async {
      print("🔍 SearchTextEvent received with query: ${event.query}");
      emit(SearchLoading());
      try {
        final results = await repository.search(event.query);
        print("✅ SearchTextEvent success, results count: ${results.length}");
        emit(SearchTextLoaded(results));
      } catch (e) {
        print("❌ SearchTextEvent error: $e");
        emit(SearchError(e.toString()));
      }
    });

    // Handle search images
    on<SearchImagesEvent>((event, emit) async {
      print("🖼️ SearchImagesEvent received with query: ${event.query}");
      emit(SearchLoading());
      try {
        final results = await repository.searchImages(event.query);
        print("✅ SearchImagesEvent success, results count: ${results.length}");
        emit(SearchImagesLoaded(results));
      } catch (e) {
        print("❌ SearchImagesEvent error: $e");
        emit(SearchError(e.toString()));
      }
    });

    // Handle search suggestions
    
  }
}
