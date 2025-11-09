import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/person_list/person_list_bloc.dart';
import '../widgets/person_card.dart';
import '../../../../core/di/injection_container.dart' as di;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PersonListBloc>()..add(const LoadPersons()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AI Chat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: BlocBuilder<PersonListBloc, PersonListState>(
          builder: (context, state) {
            if (state is PersonListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PersonListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PersonListBloc>().add(const LoadPersons());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is PersonListLoaded) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.persons.length,
                  itemBuilder: (context, index) {
                    final person = state.persons[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PersonCard(
                        person: person,
                        onTap: () {
                          context.push('/chat/${person.id}');
                        },
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

