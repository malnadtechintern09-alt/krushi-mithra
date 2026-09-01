abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server Error occurred']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Local Storage Failure']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Requested item not found']) : super(message);
}
