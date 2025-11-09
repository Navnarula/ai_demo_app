import '../entities/chat_person.dart';
import '../repositories/ai_chat_repository.dart';

class GetChatPersons {
  final AiChatRepository repository;

  GetChatPersons(this.repository);

  Future<List<ChatPerson>> call() async {
    return await repository.getChatPersons();
  }
}

