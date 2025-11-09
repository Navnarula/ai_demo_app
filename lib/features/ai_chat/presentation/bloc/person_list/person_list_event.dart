part of 'person_list_bloc.dart';

abstract class PersonListEvent extends Equatable {
  const PersonListEvent();

  @override
  List<Object> get props => [];
}

class LoadPersons extends PersonListEvent {
  const LoadPersons();
}

