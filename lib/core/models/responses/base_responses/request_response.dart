class RequestResponse {
  bool? success;
  String? error;
  dynamic data; // <- change from Map<String,dynamic> to dynamic

  RequestResponse(this.success, {this.error});

  RequestResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      data = json['body'] ?? json;
      success = json['success'];
      error = json['message'];
    } else if (json is List) {
      data = json; // assign List directly
      success = true; // maybe treat as success
    }
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': error, 'body': data};
  }
}
