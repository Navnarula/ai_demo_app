import '../../domain/entities/chat_person.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/ai_chat_repository.dart';
import '../datasources/local/ai_chat_local_data_source.dart';
import '../datasources/remote/ai_chat_remote_data_source.dart';
import '../models/chat_message_model.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatLocalDataSource localDataSource;
  final AiChatRemoteDataSource remoteDataSource;

  AiChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<ChatPerson>> getChatPersons() async {
    return await remoteDataSource.getChatPersons();
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String personId) async {
    return await localDataSource.getChatMessages(personId);
  }

  @override
  Future<ChatMessage> sendMessage(String personId, String message) async {
    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    await localDataSource.saveChatMessage(userMessage, personId);

    final aiResponse = await remoteDataSource.sendMessage(personId, message);
    await localDataSource.saveChatMessage(aiResponse, personId);

    return aiResponse;
  }
}

