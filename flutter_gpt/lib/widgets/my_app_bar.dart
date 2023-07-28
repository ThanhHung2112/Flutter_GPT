import 'theme_switch.dart';
import 'package:flutter/material.dart';
import '../providers/active_theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool isSidebarOpen;

  const MyAppBar({required this.title, required this.isSidebarOpen, Key? key})
      : super(key: key);

  @override
Widget build(BuildContext context) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ),
    leading: isSidebarOpen
        ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )
        : IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _toggleSidebar(context),
          ),
    actions: [
      Row(
        children: [
          Consumer(
            builder: (context, ref, child) => Icon(
              ref.watch(activeThemeProvider) == Themes.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
          const SizedBox(width: 8),
          const ThemeSwitch(),
        ],
      )
    ],
  );
}


  @override
  Size get preferredSize => const Size.fromHeight(60);

  void _toggleSidebar(BuildContext context) {
  Scaffold.of(context).openDrawer();
  }
}
class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Image.asset('assets/images/flutter_aIbot.png', height: 120),
      ),
    );
  }
}