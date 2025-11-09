part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final ChatPerson? person;
  final List<ChatMessage> messages;

  const ChatLoading({
    this.person,
    required this.messages,
  });

  @override
  List<Object> get props => [person ?? '', messages];
}

class ChatLoaded extends ChatState {
  final ChatPerson person;
  final List<ChatMessage> messages;

  const ChatLoaded({
    required this.person,
    required this.messages,
  });

  @override
  List<Object> get props => [person, messages];
}

class ChatError extends ChatState {
  final ChatPerson? person;
  final List<ChatMessage> messages;
  final String message;

  const ChatError({
    this.person,
    required this.messages,
    required this.message,
  });

  @override
  List<Object> get props => [person ?? '', messages, this.message];
}