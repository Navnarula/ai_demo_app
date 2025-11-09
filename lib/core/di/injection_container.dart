import 'package:get_it/get_it.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/ai_chat/data/datasources/local/ai_chat_local_data_source.dart';
import '../../features/ai_chat/data/datasources/remote/ai_chat_remote_data_source.dart';
import '../../features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import '../../features/ai_chat/domain/repositories/ai_chat_repository.dart';
import '../../features/ai_chat/domain/usecases/get_chat_persons.dart';
import '../../features/ai_chat/domain/usecases/get_chat_messages.dart';
import '../../features/ai_chat/domain/usecases/send_message.dart';
import '../../features/ai_chat/presentation/bloc/chat/chat_bloc.dart';
import '../../features/ai_chat/presentation/bloc/person_list/person_list_bloc.dart';
import '../../features/ai_chat/data/models/hive/chat_message_hive.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ChatMessageHiveAdapter());
  }

  sl.registerFactory(() => PersonListBloc(getChatPersons: sl()));
  
  sl.registerFactory(
    () => ChatBloc(
      sendMessage: sl(),
      getChatMessages: sl(),
      getChatPersons: sl(),
      ttsService: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetChatPersons(sl()));
  sl.registerLazySingleton(() => GetChatMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  sl.registerLazySingleton<AiChatRepository>(
    () => AiChatRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AiChatLocalDataSource>(
    () => AiChatLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<AiChatRemoteDataSource>(
    () => AiChatRemoteDataSourceImpl(
      dio: sl(),
      baseUrl: null,
    ),
  );

  sl.registerLazySingleton<FlutterTts>(() => FlutterTts());
  
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );
}
