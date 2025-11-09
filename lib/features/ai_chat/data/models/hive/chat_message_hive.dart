import 'package:hive/hive.dart';

class ChatMessageHive extends HiveObject {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String personId;

  ChatMessageHive({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.personId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'personId': personId,
    };
  }

  factory ChatMessageHive.fromJson(Map<String, dynamic> json) {
    return ChatMessageHive(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      personId: json['personId'] as String,
    );
  }
}

// Manual Hive Adapter
class ChatMessageHiveAdapter extends TypeAdapter<ChatMessageHive> {
  @override
  final int typeId = 0;

  @override
  ChatMessageHive read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return ChatMessageHive.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, ChatMessageHive obj) {
    writer.writeMap(obj.toJson());
  }
}
