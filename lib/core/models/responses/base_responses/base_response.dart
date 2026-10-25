class BaseResponse {
  bool? success;
  String? error;

  BaseResponse(succes, {this.success, this.error});

  BaseResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      success = json['success'] as bool?;
      error = json['error'] as String?;
    } else {
      // For raw list responses, treat as success
      success = true;
      error = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'error': error};
  }
}
