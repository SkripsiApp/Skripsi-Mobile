class ChatbotResponse {
  final bool status;
  final String message;
  final ChatbotData? data;

  ChatbotResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? ChatbotData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ChatbotData {
  final String answer;
  final List<String>? images;

  ChatbotData({
    required this.answer,
    this.images,
  });

  factory ChatbotData.fromJson(Map<String, dynamic> json) {
    return ChatbotData(
      answer: json['answer'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'images': images,
    };
  }
}
