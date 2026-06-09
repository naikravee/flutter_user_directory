part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final bool isRefresh;

  FetchUsers({this.isRefresh = false});
}

class FetchMoreUsers extends UserEvent {}

class SearchUsers extends UserEvent {
  final String query;

  SearchUsers(this.query);
}

class ClearSearch extends UserEvent {}
