import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OpenScreen extends SearchEvent {}

class OnClearHistory extends SearchEvent {
  final String? keyword;

  OnClearHistory({this.keyword});
}

class KeywordChanged extends SearchEvent {
  final String keyword;

  KeywordChanged(this.keyword);

  @override
  List<Object> get props => [this.keyword];
}
