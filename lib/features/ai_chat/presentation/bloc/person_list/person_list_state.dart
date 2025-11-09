part of 'person_list_bloc.dart';

abstract class PersonListState extends Equatable {
  const PersonListState();

  @override
  List<Object> get props => [];
}

class PersonListInitial extends PersonListState {}

class PersonListLoading extends PersonListState {}

class PersonListLoaded extends PersonListState {
  final List<ChatPerson> persons;

  const PersonListLoaded({required this.persons});

  @override
  List<Object> get props => [persons];
}

class PersonListError extends PersonListState {
  final String message;

  const PersonListError({required this.message});

  @override
  List<Object> get props => [message];
}

