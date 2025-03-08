sealed class Resource<T> {

}

class Result<T> extends Resource<T> {
  final T data;

  Result(this.data);
}

class Error<T> extends Resource<T> {
  final String message;
  final int code;
  final int apiCode;

  Error(this.message, this.code, this.apiCode);
}
