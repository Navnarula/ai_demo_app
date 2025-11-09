import 'package:dio/dio.dart';
import '../../models/chat_person_model.dart';
import '../../models/chat_message_model.dart';

abstract class AiChatRemoteDataSource {
  Future<List<ChatPersonModel>> getChatPersons();
  Future<ChatMessageModel> sendMessage(String personId, String message);
}

class AiChatRemoteDataSourceImpl implements AiChatRemoteDataSource {
  final Dio dio;
  final String? baseUrl;

  AiChatRemoteDataSourceImpl({
    required this.dio,
    this.baseUrl,
  });

  @override
  Future<List<ChatPersonModel>> getChatPersons() async {
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const [
      ChatPersonModel(
        id: '1',
        name: 'Albert Einstein',
        description: 'Theoretical physicist known for relativity theory',
        avatarEmoji: '🧑‍🔬',
        voiceLanguage: 'en-US',
      ),
      ChatPersonModel(
        id: '2',
        name: 'Isaac Newton',
        description: 'Mathematician and physicist, laws of motion',
        avatarEmoji: '⚗️',
        voiceLanguage: 'en-GB',
      ),
    ];
  }

  @override
  Future<ChatMessageModel> sendMessage(String personId, String message) async {    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock AI rspons based on person
    final responses = {
      '1': 'Fascinating question! From my perspective, time and space are relative. What do you think about the nature of reality?',
      '2': 'An excellent question! I would say that understanding the fundamental laws of nature requires careful observation and mathematical precision.',
    };
    
    final response = responses[personId] ?? 
        'Thank you for your message. I find your question quite intriguing.';
    
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}

