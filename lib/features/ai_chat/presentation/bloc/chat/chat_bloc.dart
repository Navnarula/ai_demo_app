import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/chat_person.dart';
import '../../../domain/usecases/send_message.dart';
import '../../../domain/usecases/get_chat_messages.dart';
import '../../../domain/usecases/get_chat_persons.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final GetChatMessages getChatMessages;
  final GetChatPersons getChatPersons;
  final FlutterTts ttsService;
  String? currentPersonId;
  String? currentVoiceLanguage;

  ChatBloc({
    required this.sendMessage,
    required this.getChatMessages,
    required this.getChatPersons,
    required this.ttsService,
  }) : super(ChatInitial()) {
    on<InitializeChat>(_onInitializeChat);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendUserMessage>(_onSendUserMessage);
    on<AddMessage>(_onAddMessage);
    on<SpeakMessage>(_onSpeakMessage);
    on<ClearChat>(_onClearChat);
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await ttsService.setLanguage('en-US');
    await ttsService.setSpeechRate(0.5);
    await ttsService.setVolume(1.0);
    await ttsService.setPitch(1.0);
  }

  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(person: null, messages: []));
    
    try {
      // Fetch person details
      final persons = await getChatPersons();
      final person = persons.firstWhere(
        (p) => p.id == event.personId,
        orElse: () => throw Exception('Person not found'),
      );
      
      currentPersonId = person.id;
      currentVoiceLanguage = person.voiceLanguage;
      await ttsService.setLanguage(person.voiceLanguage);
      
      // Load messages from local DB
      final messages = await getChatMessages(event.personId);
      
      emit(ChatLoaded(person: person, messages: messages));

    } catch (e) {
      emit(ChatError(
        person: null,
        messages: [],
        message: 'Failed to initialize chat: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      try {
        final messages = await getChatMessages(event.personId);
        emit(ChatLoaded(person: currentState.person, messages: messages));
      } catch (e) {
        emit(ChatError(
          person: currentState.person,
          messages: currentState.messages,
          message: 'Failed to load chat messages: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onSendUserMessage(
    SendUserMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      );

      // Show user message immediately
      emit(ChatLoaded(
        person: currentState.person,
        messages: [...currentState.messages, userMessage],
      ));

      emit(ChatLoading(
        person: currentState.person,
        messages: [...currentState.messages, userMessage],
      ));

      try {
        final response = await sendMessage(currentPersonId!, event.message);
        emit(ChatLoaded(
          person: currentState.person,
          messages: [...currentState.messages, userMessage, response],
        ));
        add(SpeakMessage(message: response.content));
      } catch (e) {
        emit(ChatError(
          person: currentState.person,
          messages: currentState.messages,
          message: e.toString(),
        ));
      }
    }
  }

  Future<void> _onAddMessage(
    AddMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(ChatLoaded(
        person: currentState.person,
        messages: [...currentState.messages, event.message],
      ));
    }
  }

  Future<void> _onSpeakMessage(
    SpeakMessage event,
    Emitter<ChatState> emit,
  ) async {
    await ttsService.speak(event.message);
  }

  Future<void> _onClearChat(
    ClearChat event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(ChatLoaded(person: currentState.person, messages: []));
    }
  }
}