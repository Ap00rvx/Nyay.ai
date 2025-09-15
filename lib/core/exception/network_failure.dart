
/// A simple failure model for networking errors.
sealed class NetworkFailure {
  final String message;
  final int? statusCode;
  final dynamic details;
  const NetworkFailure(this.message, {this.statusCode, this.details});

  @override
  String toString() =>
      'NetworkFailure(message: '
      '$message'
      ', statusCode: '
      '$statusCode'
      ', details: '
      '$details'
      ')';
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure(String message) : super(message);
}

class NoConnectionFailure extends NetworkFailure {
  const NoConnectionFailure(String message) : super(message);
}

class CancelledFailure extends NetworkFailure {
  const CancelledFailure(String message) : super(message);
}

class UnauthorizedFailure extends NetworkFailure {
  const UnauthorizedFailure(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

class ForbiddenFailure extends NetworkFailure {
  const ForbiddenFailure(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

class NotFoundFailure extends NetworkFailure {
  const NotFoundFailure(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

class BadRequestFailure extends NetworkFailure {
  const BadRequestFailure(String message, {int? statusCode, dynamic details})
    : super(message, statusCode: statusCode, details: details);
}

class ConflictFailure extends NetworkFailure {
  const ConflictFailure(String message, {int? statusCode, dynamic details})
    : super(message, statusCode: statusCode, details: details);
}

class ServerFailure extends NetworkFailure {
  const ServerFailure(String message, {int? statusCode, dynamic details})
    : super(message, statusCode: statusCode, details: details);
}

class SerializationFailure extends NetworkFailure {
  const SerializationFailure(String message, {dynamic details})
    : super(message, details: details);
}

class UnknownFailure extends NetworkFailure {
  const UnknownFailure(String message, {int? statusCode, dynamic details})
    : super(message, statusCode: statusCode, details: details);
}
