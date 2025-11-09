import 'package:go_router/go_router.dart';
import '../../features/ai_chat/presentation/pages/home_page.dart';
import '../../features/ai_chat/presentation/pages/chat_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/chat/:personId',
        name: 'chat',
        builder: (context, state) {
          final personId = state.pathParameters['personId'] ?? '';
          return ChatPage(personId: personId);
        },
      ),
    ],
  );
}
