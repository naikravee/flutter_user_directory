class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://reqres.in/api';

  // Pagination
  static const int perPage = 10;

  // Hive
  static const String usersBox = 'users_box';

  // Cache Keys
  static const String cachedUsersKey = 'cached_users';

  // Timeouts
  static const int requestTimeoutSeconds = 15;
}
