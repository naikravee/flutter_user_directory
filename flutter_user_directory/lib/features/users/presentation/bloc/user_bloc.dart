import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';
import '../../data/repository/user_repository_impl.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryImpl repository;

  UserBloc({required this.repository}) : super(UserState.initial()) {
    on<FetchUsers>(_onFetchUsers);
    on<FetchMoreUsers>(_onFetchMoreUsers);
    on<SearchUsers>(_onSearchUsers);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    try {
      if (event.isRefresh) {
        emit(UserState.initial().copyWith(status: UserStatus.loading));
      } else {
        emit(state.copyWith(status: UserStatus.loading));
      }

      final response = await repository.getUsers(page: 1, perPage: 10);

      final totalUsers = response.total;

      final users = response.users;

      emit(
        state.copyWith(
          status: users.isEmpty ? UserStatus.empty : UserStatus.success,
          users: users,
          filteredUsers: users,
          page: 1,
          hasReachedMax: users.length == totalUsers,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: UserStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFetchMoreUsers(
    FetchMoreUsers event,
    Emitter<UserState> emit,
  ) async {
    if (state.hasReachedMax || state.status == UserStatus.loadingMore) return;

    try {
      emit(state.copyWith(status: UserStatus.loadingMore));

      final nextPage = state.page + 1;

      print([
        'next page',
        nextPage,
        state.page,
        state.hasReachedMax,
        nextPage + 1,
      ]);

      final response = await repository.getUsers(page: nextPage, perPage: 10);

      final totalUsers = response.total;

      final updatedUsers = List<UserEntity>.from(state.users)
        ..addAll(response.users);

      emit(
        state.copyWith(
          status: UserStatus.success,
          users: updatedUsers,
          filteredUsers: _applySearch(updatedUsers, state.searchQuery),
          page: nextPage,
          hasReachedMax: updatedUsers.length == totalUsers,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: UserStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    final query = event.query.toLowerCase();

    final filtered = state.users.where((user) {
      return user.firstName.toLowerCase().contains(query) ||
          user.lastName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();

    if (filtered.isEmpty) {
      emit(state.copyWith(status: UserStatus.empty));
    } else {
      emit(state.copyWith(searchQuery: query, filteredUsers: filtered));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<UserState> emit) {
    emit(
      state.copyWith(
        status: state.users.isEmpty ? UserStatus.empty : UserStatus.success,
        searchQuery: '',
        filteredUsers: state.users,
      ),
    );
  }

  List<UserEntity> _applySearch(List<UserEntity> users, String query) {
    if (query.isEmpty) return users;

    return users.where((user) {
      return user.firstName.toLowerCase().contains(query) ||
          user.lastName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
  }
}
