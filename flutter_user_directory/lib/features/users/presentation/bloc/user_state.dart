part of 'user_bloc.dart';

enum UserStatus { initial, loading, loadingMore, success, failure, empty }

class UserState extends Equatable {
  final UserStatus status;
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;
  final bool hasReachedMax;
  final int page;
  final String errorMessage;
  final String searchQuery;

  const UserState({
    required this.status,
    required this.users,
    required this.filteredUsers,
    required this.hasReachedMax,
    required this.page,
    required this.errorMessage,
    required this.searchQuery,
  });

  factory UserState.initial() {
    return const UserState(
      status: UserStatus.initial,
      users: [],
      filteredUsers: [],
      hasReachedMax: false,
      page: 1,
      errorMessage: '',
      searchQuery: '',
    );
  }

  UserState copyWith({
    UserStatus? status,
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
    String? searchQuery,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    users,
    filteredUsers,
    hasReachedMax,
    page,
    errorMessage,
    searchQuery,
  ];
}
