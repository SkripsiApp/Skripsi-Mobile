class ChatbotModel {
  final String question;

  ChatbotModel({
    required this.question,
  });

  factory ChatbotModel.fromJson(Map<String, dynamic> json) {
    return ChatbotModel(
      question: json['question'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
    };
  }
}
