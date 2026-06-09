import 'package:flutter/material.dart';
import 'package:flutter_user_directory/features/users/presentation/screens/user_detail_screen.dart';
import '../../domain/entities/user_entity.dart';

class UserListWidget extends StatelessWidget {
  final List<UserEntity> users;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const UserListWidget({
    super.key,
    required this.users,
    required this.scrollController,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: users.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= users.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final user = users[index];
        print(['user avatar', user.avatar]);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            );
          },
          child: ListTile(
            leading: user.avatar != ''
                ? CircleAvatar(backgroundImage: NetworkImage(user.avatar))
                : CircleAvatar(child: Text(user.fullName[0])),
            title: Text(user.fullName),
            subtitle: Text(user.email),
          ),
        );
      },
    );
  }
}
