import 'package:get/get.dart';
import 'package:skripsi_app/response/chatbot_response.dart';
import 'package:skripsi_app/service/service.dart';

class ChatbotController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;

  void sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    // Add user message to the list
    messages.add(ChatMessage(
      content: question,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    isLoading.value = true;

    try {
      ChatbotResponse response = await _apiService.chatbot(question);

      if (response.status) {
        // Add bot message to the list
        messages.add(ChatMessage(
          content: response.data?.answer ?? 'Sorry, I couldn\'t process that.',
          isUser: false,
          timestamp: DateTime.now(),
          recommendation: response.data?.recommendation ?? [],
        ));
      } else {
        // Add error message
        messages.add(ChatMessage(
          content: response.message,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
    } catch (e) {
      // Add error message in case of exception
      messages.add(ChatMessage(
        content: 'An error occurred. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    isLoading.value = false;
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<ProductRecommendation>? recommendation;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.recommendation,
  });
}