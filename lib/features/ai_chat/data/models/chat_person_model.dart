import '../../domain/entities/chat_person.dart';

class ChatPersonModel extends ChatPerson {
  const ChatPersonModel({
    required super.id,
    required super.name,
    required super.description,
    required super.avatarEmoji,
    required super.voiceLanguage,
  });

  factory ChatPersonModel.fromJson(Map<String, dynamic> json) {
    return ChatPersonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      avatarEmoji: json['avatarEmoji'] as String,
      voiceLanguage: json['voiceLanguage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatarEmoji': avatarEmoji,
      'voiceLanguage': voiceLanguage,
    };
  }
}

