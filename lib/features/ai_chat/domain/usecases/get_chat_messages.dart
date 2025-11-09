import '../entities/chat_message.dart';
import '../repositories/ai_chat_repository.dart';

class GetChatMessages {
  final AiChatRepository repository;

  GetChatMessages(this.repository);

  Future<List<ChatMessage>> call(String personId) async {
    return await repository.getChatMessages(personId);
  }
}

