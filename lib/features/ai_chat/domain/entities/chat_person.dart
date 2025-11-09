import 'package:equatable/equatable.dart';

class ChatPerson extends Equatable {
  final String id;
  final String name;
  final String description;
  final String avatarEmoji;
  final String voiceLanguage;

  const ChatPerson({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarEmoji,
    required this.voiceLanguage,
  });

  @override
  List<Object> get props => [id, name, description, avatarEmoji, voiceLanguage];
}

