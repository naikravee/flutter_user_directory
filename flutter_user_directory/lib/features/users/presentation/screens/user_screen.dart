import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_directory/core/widgets/empty_state_widget.dart';

import '../bloc/user_bloc.dart';
import '../widgets/user_list_widget.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<UserBloc>().add(FetchUsers());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UserBloc>().add(FetchMoreUsers());
    }
  }

  Future<void> _onRefresh() async {
    context.read<UserBloc>().add(FetchUsers(isRefresh: true));
  }

  void _onSearchChanged(String value) {
    if (_searchController.text.isNotEmpty) {
      context.read<UserBloc>().add(SearchUsers(value));
    } else {
      context.read<UserBloc>().add(ClearSearch());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              builder: (context, state) {
                if (state.status == UserStatus.loading && state.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == UserStatus.failure && state.users.isEmpty) {
                  return Center(
                    child: EmptyStateWidget(
                      title: state.errorMessage,
                      subtitle: '',
                      icon: Icons.people_outline,
                      onRetry: _onRefresh,
                    ),
                  );
                }

                if (state.status == UserStatus.empty &&
                    _searchController.text.isNotEmpty) {
                  return Center(
                    child: EmptyStateWidget(
                      title: 'No users match your search',
                      subtitle: 'Check spelling or try a different name',
                      icon: Icons.person_search_outlined,
                    ),
                  );
                }

                if (state.status == UserStatus.empty) {
                  return Center(
                    child: EmptyStateWidget(
                      title: 'No users available',
                      subtitle: 'There are no users to display at the moment',
                      icon: Icons.people_outline,
                      onRetry: _onRefresh,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: UserListWidget(
                    users: state.filteredUsers,
                    scrollController: _scrollController,
                    isLoadingMore: state.status == UserStatus.loadingMore,
                  ),
                );
              },
              listener: (BuildContext context, UserState state) {
                if (state.status == UserStatus.failure &&
                    state.errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Search users...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
