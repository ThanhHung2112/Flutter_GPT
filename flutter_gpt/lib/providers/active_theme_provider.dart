import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeThemeProvider = StateProvider<Themes>(
  (ref) => Themes.light,
);

enum Themes {
  dark,
  light,
}
