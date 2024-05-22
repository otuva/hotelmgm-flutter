class ApiResponse {
  final bool succeeded;
  final String message;
  final String? errors;
  final Map<String, dynamic>? data;

  const ApiResponse({
    required this.succeeded,
    required this.message,
    required this.errors,
    required this.data,
  });


  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      succeeded: json['succeeded'] ?? json['Succeeded'], 
      message: json['message'] ?? json['Message'],
      errors: json['errors'] ?? json['Errors'],
      data: json['data'] ?? json['Data'],
    );
  }
}
