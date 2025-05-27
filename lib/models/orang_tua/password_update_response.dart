class PasswordUpdateResponse {
  final String message;

  PasswordUpdateResponse({required this.message});

  factory PasswordUpdateResponse.fromJson(Map<String, dynamic> json) {
    return PasswordUpdateResponse(message: json['message']);
  }
}
