import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_person.dart';
import '../../../domain/usecases/get_chat_persons.dart';

part 'person_list_event.dart';
part 'person_list_state.dart';

class PersonListBloc extends Bloc<PersonListEvent, PersonListState> {
  final GetChatPersons getChatPersons;

  PersonListBloc({required this.getChatPersons}) : super(PersonListInitial()) {
    on<LoadPersons>(_onLoadPersons);
  }

  Future<void> _onLoadPersons(
    LoadPersons event,
    Emitter<PersonListState> emit,
  ) async {
    emit(PersonListLoading());
    try {
      final persons = await getChatPersons();
      emit(PersonListLoaded(persons: persons));
    } catch (e) {
      emit(PersonListError(message: e.toString()));
    }
  }
}

