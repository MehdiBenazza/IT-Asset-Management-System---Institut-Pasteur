/// Exception personnalisée pour les erreurs liées au repository.
class DataRepositoryException implements Exception {
  final String message;
  DataRepositoryException(this.message);
  @override
  String toString() => 'DataRepositoryException: $message';
}

/// Exception personnalisée pour les erreurs réseau.
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

/// Exception personnalisée pour les erreurs de validation.
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => 'ValidationException: $message';
}