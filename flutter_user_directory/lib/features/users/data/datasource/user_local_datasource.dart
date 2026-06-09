import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UserLocalDatasource {
  Future<void> cacheUsers(List<UserModel> users);

  Future<List<UserModel>> getCachedUsers();

  Future<void> clearCache();
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  final Box box;

  UserLocalDatasourceImpl(this.box);

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    try {
      await box.put(
        AppConstants.cachedUsersKey,
        users.map((e) => e.toJson()).toList(),
      );
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<UserModel>> getCachedUsers() async {
    try {
      final data = box.get(AppConstants.cachedUsersKey);

      if (data == null) {
        return [];
      }

      return (data as List)
          .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    await box.delete(AppConstants.cachedUsersKey);
  }
}
