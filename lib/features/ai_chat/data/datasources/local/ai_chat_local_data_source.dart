import 'package:hive_flutter/hive_flutter.dart';
import '../../models/hive/chat_message_hive.dart';
import '../../models/chat_message_model.dart';

abstract class AiChatLocalDataSource {
  Future<List<ChatMessageModel>> getChatMessages(String personId);
  Future<void> saveChatMessage(ChatMessageModel message, String personId);
  Future<void> clearChatHistory(String personId);
}

class AiChatLocalDataSourceImpl implements AiChatLocalDataSource {
  static const String _chatBoxName = 'chat_messages';

  Future<Box> get _chatBox async {
    if (!Hive.isBoxOpen(_chatBoxName)) {
      return await Hive.openBox(_chatBoxName);
    }
    return Hive.box(_chatBoxName);
  }

  @override
  Future<List<ChatMessageModel>> getChatMessages(String personId) async {
    try {
      final box = await _chatBox;
      final messages = <ChatMessageModel>[];
      
      for (var key in box.keys) {
        final data = box.get(key);
        if (data is Map) {
          final hiveMsg = ChatMessageHive.fromJson(Map<String, dynamic>.from(data));
          if (hiveMsg.personId == personId) {
            messages.add(ChatMessageModel(
              id: hiveMsg.id,
              content: hiveMsg.content,
              isUser: hiveMsg.isUser,
              timestamp: hiveMsg.timestamp,
            ));
          }
        }
      }
      
      // Sort by timestamp
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveChatMessage(ChatMessageModel message, String personId) async {
    try {
      final box = await _chatBox;
      final hiveMessage = ChatMessageHive(
        id: message.id,
        content: message.content,
        isUser: message.isUser,
        timestamp: message.timestamp,
        personId: personId,
      );
      await box.put(message.id, hiveMessage.toJson());
    } catch (e) {
      // Handle error silently for POC
    }
  }

  @override
  Future<void> clearChatHistory(String personId) async {
    try {
      final box = await _chatBox;
      final keysToDelete = <String>[];
      for (var key in box.keys) {
        final data = box.get(key);
        if (data is Map) {
          final hiveMsg = ChatMessageHive.fromJson(Map<String, dynamic>.from(data));
          if (hiveMsg.personId == personId) {
            keysToDelete.add(key.toString());
          }
        }
      }
      await box.deleteAll(keysToDelete);
    } catch (e) {
      // Handle error silently for POC
    }
  }
}

