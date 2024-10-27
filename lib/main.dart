import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_list/object/app_router.dart';

void main() {
  final appRouter = AppRouter();

  runApp(MyApp(router: appRouter.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
