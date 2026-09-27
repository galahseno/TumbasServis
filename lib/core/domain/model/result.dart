sealed class Result<T> {
  const factory Result.ok(T value) = Ok<T>._;
  const factory Result.error(Exception error) = Error<T>._;
}

final class Ok<T> implements Result<T> {
  const Ok._(this.value);

  final T value;
}

final class Error<T> implements Result<T> {
  const Error._(this.error);

  final Exception error;
}
