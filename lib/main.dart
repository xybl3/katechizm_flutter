import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katechizm_flutter/views/home_screen.dart';
import 'package:katechizm_flutter/views/main_tab_screen.dart';

void main() {
  runApp(const App());
}

final _router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => MainTabScreen())],
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? ThemeData.dark()
              : ThemeData.light(),
      routerConfig: _router,
    );
  }
}
