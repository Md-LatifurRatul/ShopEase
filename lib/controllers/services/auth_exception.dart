class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({required this.message, required this.code});

  @override
  String toString() {
    return "AuthException : $message ${code != null ? "(Code: $code)" : ""}";
  }

  Map<String, String?> toJson() {
    return {"message": message, "code": code};
  }
}
