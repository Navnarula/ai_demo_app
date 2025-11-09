import '../entities/chat_person.dart';
import '../entities/chat_message.dart';

abstract class AiChatRepository {
  Future<List<ChatPerson>> getChatPersons();
  Future<List<ChatMessage>> getChatMessages(String personId);
  Future<ChatMessage> sendMessage(String personId, String message);
}

