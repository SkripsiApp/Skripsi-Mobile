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
  final List<ProductRecommendation> recommendation;

  ChatbotData({
    required this.answer,
    required this.recommendation,
  });

  factory ChatbotData.fromJson(Map<String, dynamic> json) {
    return ChatbotData(
      answer: json['answer'] ?? '',
      recommendation: json['recommendation'] != null
          ? (json['recommendation'] as List)
              .map((item) => ProductRecommendation.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'recommendation': recommendation.map((item) => item.toJson()).toList(),
    };
  }
}

class ProductRecommendation {
  final String id;
  final String name;
  final int price;
  final int sold;
  final String image;

  ProductRecommendation({
    required this.id,
    required this.name,
    required this.price,
    required this.sold,
    required this.image,
  });

  factory ProductRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductRecommendation(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      sold: json['sold'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'sold': sold,
      'image': image,
    };
  }
}
