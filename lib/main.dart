import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:live_match_blogger/features/timer/pages/timer_page.dart';
import 'package:live_match_blogger/features/timer/utils/theme.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      debugShowCheckedModeBanner: false,
      theme: defaultTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home: const TimerPage(),
    );
  }
}