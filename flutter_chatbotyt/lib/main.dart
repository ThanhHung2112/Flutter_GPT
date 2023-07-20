import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chatbotyt/constants/themes.dart';
import 'package:flutter_chatbotyt/screens/chat_screen.dart';
import 'package:flutter_chatbotyt/providers/active_theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: App()));
} 

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
      home: const ChatScreen(),
    );
  }
}
