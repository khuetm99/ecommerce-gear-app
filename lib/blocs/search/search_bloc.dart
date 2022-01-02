import 'package:ecommerce_app/blocs/search/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/data/repository/product_repository/firebase_product_repo.dart';
import 'package:ecommerce_app/utils/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _productRepository = FirebaseProductRepository();

  SearchBloc() : super(Searching());

  /// Debounce search query changed event
  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events, transitionFn) {
    var debounceStream = events
        .where((event) => event is KeywordChanged)
        .debounceTime(Duration(milliseconds: 500));
    var nonDebounceStream = events.where((event) => event is! KeywordChanged);
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is OpenScreen) {
      yield* _mapOpenScreenToState();
    } else if (event is KeywordChanged) {
      yield* _mapKeywordChangedToState(event.keyword);
    } else if (event is OnClearHistory) {
      yield* _mapOnClearHistoryToState(event.keyword as String);
    }
  }

  Stream<SearchState> _mapOpenScreenToState() async* {
    try {
      List<String> recentKeywords = await _getRecentKeywords();
      yield SuggestionLoaded(
        recentKeywords: recentKeywords,
        hotKeywords: hotKeywords,
      );
    } catch (e) {
      yield SearchFailure(e.toString());
    }
  }

  Stream<SearchState> _mapKeywordChangedToState(String keyword) async* {
    yield Searching();
    try {
      List<String> recentKeywords = await _getRecentKeywords();
      if (keyword.isEmpty) {
        yield SuggestionLoaded(
          recentKeywords: recentKeywords,
          hotKeywords: hotKeywords,
        );
      } else {
        // Get products by keywords
        List<Product> products = await _productRepository.fetchProducts();
        List<Product> results = products
            .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
        yield ResultsLoaded(results);
        // Store keyword to local
        if (!recentKeywords.contains(keyword.toLowerCase())) {
          if (recentKeywords.length > 9) {
            recentKeywords.removeAt(0);
          }
          recentKeywords.add(keyword.toLowerCase());
          await UtilPreferences.setStringList("recentKeywords", recentKeywords);
        }
      }
    } catch (e) {
      yield SearchFailure(e.toString());
    }
  }

  Stream<SearchState> _mapOnClearHistoryToState(String keyword) async* {
    try {
      if (keyword == null) {
        await UtilPreferences.remove(
          "recentKeywords",
        );
        yield SuggestionLoaded(
          recentKeywords: [],
          hotKeywords: hotKeywords,
        );

      } else {
        List<String> recentKeywords = await _getRecentKeywords();
        recentKeywords.remove(keyword);
        UtilPreferences.setStringList("recentKeywords", recentKeywords);

        yield SuggestionLoaded(
          recentKeywords: recentKeywords,
          hotKeywords: hotKeywords,
        );
      }

    } catch (e) {
      yield SearchFailure(e.toString());
    }
  }

  Future<List<String>> _getRecentKeywords() async {
    return UtilPreferences.getStringList("recentKeywords") ?? [];
  }
}

const List<String> hotKeywords = [
  "Akko",
  "Razer",
  "Dragon ball",
  "keyboard",
];
