import 'package:go_router/go_router.dart';
import 'package:to_do_list/page/connexion.dart';
import 'package:to_do_list/page/enregistrer.dart';
import 'package:to_do_list/page/home_page.dart';
import 'package:to_do_list/page/welcome.dart';

class AppRouter {
  final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Welcome(),
    ),
    GoRoute(
      path: '/connexion',
      builder: (context, state) => const Connexion(),
    ),
    GoRoute(
      path: '/enregistrer',
      builder: (context, state) => const Enregistrer(),
    ),
    GoRoute(path: '/home_page', builder: (context, state) => const HomePage()),
  ]);
}
