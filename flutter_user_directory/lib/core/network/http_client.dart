import 'dart:async';
import 'dart:convert';

import 'package:flutter_user_directory/core/network/connectivity_service.dart';
import 'package:flutter_user_directory/features/users/data/models/user_response_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class UserRemoteDatasource {
  Future<UserResponseModel> getUsers({required int page, required int perPage});
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final http.Client client;
  final ConnectivityService connectivityService;

  UserRemoteDatasourceImpl(this.client, this.connectivityService);

  @override
  Future<UserResponseModel> getUsers({
    required int page,
    required int perPage,
  }) async {
    try {
      final hasNet = await connectivityService.hasInternet();

      print(['hasnet', hasNet]);

      if (!hasNet) {
        throw NetworkException().message;
      }

      final response = await client
          .get(
            Uri.parse(
              '${AppConstants.baseUrl}/users?page=$page&per_page=$perPage',
            ),
            headers: {'x-api-key': 'reqres_2e7ea17f191d41fd9fad63c36a73b060'},
          )
          .timeout(const Duration(seconds: 30));

      print(['response', response]);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return UserResponseModel.fromJson(jsonData);
      }

      throw ServerException().message;
    } on ServerException {
      rethrow;
    } on TimeoutException {
      throw RequestTimeoutException().message;
    } on Exception {
      throw NetworkException().message;
    }
  }
}
