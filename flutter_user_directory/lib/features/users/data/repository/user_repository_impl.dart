import 'package:flutter_user_directory/core/network/http_client.dart';

import '../datasource/user_local_datasource.dart';
import '../models/user_response_model.dart';

class UserRepositoryImpl {
  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  Future<UserResponseModel> getUsers({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await remoteDatasource.getUsers(
        page: page,
        perPage: perPage,
      );

      await localDatasource.cacheUsers(response.users);

      return response;
    } catch (_) {
      final cachedUsers = await localDatasource.getCachedUsers();

      if (cachedUsers.isNotEmpty) {
        return UserResponseModel(
          page: 1,
          perPage: cachedUsers.length,
          total: cachedUsers.length,
          totalPages: 1,
          users: cachedUsers,
        );
      }

      rethrow;
    }
  }
}
