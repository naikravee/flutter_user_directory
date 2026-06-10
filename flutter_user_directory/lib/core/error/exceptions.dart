// class ServerException implements Exception {}

// class CacheException implements Exception {}

// class NetworkException implements Exception {}

// class RequestTimeoutException implements Exception {}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server error occurred"]);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = "Cache error occurred"]);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "No internet connection"]);
}

class RequestTimeoutException implements Exception {
  final String message;
  RequestTimeoutException([this.message = "Request timed out"]);
}
