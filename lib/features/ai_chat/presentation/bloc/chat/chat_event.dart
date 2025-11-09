part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class InitializeChat extends ChatEvent {
  final String personId;

  const InitializeChat({
    required this.personId,
  });

  @override
  List<Object> get props => [personId];
}

class SendUserMessage extends ChatEvent {
  final String message;

  const SendUserMessage(this.message);

  @override
  List<Object> get props => [message];
}

class AddMessage extends ChatEvent {
  final ChatMessage message;

  const AddMessage(this.message);

  @override
  List<Object> get props => [message];
}

class SpeakMessage extends ChatEvent {
  final String message;

  const SpeakMessage({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadChatMessages extends ChatEvent {
  final String personId;

  const LoadChatMessages({required this.personId});

  @override
  List<Object> get props => [personId];
}

class ClearChat extends ChatEvent {
  const ClearChat();
}

