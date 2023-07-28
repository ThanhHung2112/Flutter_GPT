import 'constants/themes.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'providers/active_theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpt_flutter/screens/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        themeMode:
            activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
        home: HomePage());
    // FutureBuilder(builder: ((context, snapshot) {
    //   if (snapshot.hasError) {
    //     print("snapshot error: " ); //+ snapshot.toString()
    //   }
    //   if (snapshot.connectionState == ConnectionState.done) {
    //     return MaterialApp(
    //       theme: lightTheme,
    //       darkTheme: darkTheme,
    //       debugShowCheckedModeBanner: false,
    //       themeMode:
    //           activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
    //       home: HomePage(),

    //     );
    //   }
    //   return Center(child: CircularProgressIndicator());
    // }));
    //
  }
}
