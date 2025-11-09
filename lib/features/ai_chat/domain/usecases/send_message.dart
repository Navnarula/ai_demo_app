import '../entities/chat_message.dart';
import '../repositories/ai_chat_repository.dart';

class SendMessage {
  final AiChatRepository repository;

  SendMessage(this.repository);

  Future<ChatMessage> call(String personId, String message) async {
    return await repository.sendMessage(personId, message);
  }
}

