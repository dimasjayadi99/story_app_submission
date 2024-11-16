class ResponseModel {
  final bool error;
  final String message;

  ResponseModel({required this.error, required this.message});

  factory ResponseModel.fromJson(Map<String, dynamic> map) {
    return ResponseModel(error: map['error'], message: map['message']);
  }
}
