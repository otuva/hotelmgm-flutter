class ApiErrorResponse {
  final String? type;
  final String? title;
  final int status;
  final String? traceId;
  final String errors;

  const ApiErrorResponse({
    required this.type,
    required this.title,
    required this.status,
    required this.traceId,
    required this.errors,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      type: json['type'] ?? json['Type'],
      title: json['title'] ?? json['Title'],
      status: json['status'] ?? json['Status'],
      traceId: json['traceId'] ?? json['TraceId'],
      errors: (json['errors'] ?? json['Errors'])[json['errors'].keys.first][0], 
    );
  }
}
