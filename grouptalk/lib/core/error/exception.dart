class ServerException implements Exception {
  final String errorMessage;
  ServerException({required this.errorMessage});

  @override
  String toString() {
    return 'Server Error: $errorMessage';
  }
}

class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});

  @override
  String toString() {
    return 'Cache Error: $errorMessage';
  }
}
