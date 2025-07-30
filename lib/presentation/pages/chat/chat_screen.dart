import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:clisence/core/configs/theme/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextToSpeech tts = TextToSpeech();

  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user', firstName: 'User');
  final _aiUser = const types.User(id: 'ai', firstName: 'AI Assistant');

  // Initialize Gemini
  final model = GenerativeModel(
    model: 'gemini-2.0-flash-001',
    // usind dotenv
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );

  // Define theme at class level
  final _chatTheme = DefaultChatTheme(
    primaryColor: AppColors.primaryColor,
    secondaryColor: Colors.grey.shade200,
    inputBackgroundColor: Colors.white,
    inputTextColor: Colors.black,
    inputTextDecoration: const InputDecoration.collapsed(
      hintText: 'Type your message...',
      hintStyle: TextStyle(color: Colors.grey),
    ),
  );

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    // Show typing indicator
    final typingMessage = types.TextMessage(
      author: _aiUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'typing-${const Uuid().v4()}',
      text: '...',
    );

    setState(() {
      _messages.insert(0, typingMessage);
    });

    try {
      // Get response from Gemini
      final content = Content.text('''
You are an expert agricultural advisor providing specific, actionable advice to farmers.
Please provide specific adaptation strategies for these crops given the current conditions. Include:
1. Immediate actions the farmer should take
2. Potential risks to watch out for
3. Recommended timing for next steps
4. Any specific varieties or practices that would be beneficial

Keep the advice practical, localized, and easy to understand. Focus on low-cost, high-impact recommendations.

Format the response in clear, concise bullet points with emojis for better readability.

${message.text}
''');
      final response = await model.generateContent([content]);

      final responseText =
          response.text ?? 'I am not sure how to respond to that.';

      // Remove typing indicator
      setState(() {
        _messages.removeWhere((msg) => msg.id.startsWith('typing-'));
      });

      // Add AI response
      final aiResponse = types.TextMessage(
        author: _aiUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: responseText,
      );

      setState(() {
        _messages.insert(0, aiResponse);
      });
    } catch (e) {
      // Remove typing indicator on error
      setState(() {
        _messages.removeWhere((msg) => msg.id.startsWith('typing-'));
      });

      // Show error message
      final errorMessage = types.TextMessage(
        author: _aiUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'Sorry, I encountered an error. Please try again.',
      );

      setState(() {
        _messages.insert(0, errorMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add null checks
    if (_messages == null || _user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('AI Assistant', semanticsLabel: 'Chat screen title'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
              theme: _chatTheme,
              customMessageBuilder: (message, {required int messageWidth}) {
                return _buildCustomMessage(message, messageWidth: messageWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMessage(
    types.Message message, {
    required int messageWidth,
  }) {
    if (message is types.TextMessage) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.author.id == _user.id
                      ? _chatTheme.primaryColor
                      : _chatTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.author.id == _user.id
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    if (message.author.id == _aiUser.id)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 20),
                            onPressed: () => tts.speak(message.text),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              // Add clipboard functionality if needed
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
