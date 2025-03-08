class ApiError implements Exception {
  final dynamic message;
  final int code;

  ApiError({required this.message, required this.code});
}

class ParseError implements Exception {
  final String message;

  ParseError({required this.message,});
}