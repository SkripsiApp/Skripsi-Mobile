import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3ABEF9),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildBotMessage("Hello! How can I help you today?", "11:35"),
                _buildUserMessage(
                    "Hi! I have a question about your services.", "11:35"),
                _buildBotMessage(
                    "I'd be happy to help. What would you like to know?",
                    "11:35"),
              ],
            ),
          ),
          _buildInputField(),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildBotMessage(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tia Bot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(message),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'You',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(message),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Apa yang ingin anda tanyakan?',
                filled: true,
                fillColor: Colors.lightBlue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Produk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'Chatbot',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'Voucher',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
      ],
    );
  }
}

